# syntax=docker/dockerfile:1
# Tudovu-generated for Next.js. Requires `output: "standalone"` in next.config.
FROM node:22-alpine AS build
WORKDIR /app
# Install pnpm (matches the pnpm-lock.yaml in the repo)
RUN corepack enable && corepack prepare pnpm@latest --activate
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml .npmrc ./
RUN pnpm install --frozen-lockfile
COPY . .
ENV NEXT_TELEMETRY_DISABLED=1
RUN pnpm run build

FROM node:22-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production PORT=3000 NEXT_TELEMETRY_DISABLED=1
RUN addgroup -S app && adduser -S app -G app
# Standalone output bundles only the server + traced deps it needs.
COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static ./.next/static
COPY --from=build /app/public ./public
USER app
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -q -O- "http://127.0.0.1:3000/healthz" || exit 1
CMD ["node","server.js"]

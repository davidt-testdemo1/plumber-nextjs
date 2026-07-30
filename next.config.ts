import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  // Required for the Dockerfile's multi-stage build: the runtime stage copies
  // from .next/standalone which is only produced in standalone output mode.
  output: 'standalone',
};

export default nextConfig;

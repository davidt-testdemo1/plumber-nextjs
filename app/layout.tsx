// Force every page in this app to render at request time.
// This prevents `next build` from prerendering pages that query the PostgreSQL
// database, which is only available at runtime (not during CI builds).
export const dynamic = 'force-dynamic';

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}

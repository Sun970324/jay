const { createClient } = require('@supabase/supabase-js');

function escapeHtml(str) {
  if (!str) return '';
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

module.exports = async function handler(req, res) {
  const { id } = req.query;
  const proto = req.headers['x-forwarded-proto'] || 'https';
  const host = req.headers['x-forwarded-host'] || req.headers['host'];
  const baseUrl = `${proto}://${host}`;
  const detailUrl = `${baseUrl}/detail/${id}`;
  const flutterUrl = `${detailUrl}?flutter=1`;

  let title = '제이 - 의료복지혜택 찾기';
  const description = '당신에게 맞는 의료복지혜택을 확인해보세요';

  try {
    const supabase = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_ANON_KEY
    );
    const { data } = await supabase
      .from('postings')
      .select('title')
      .eq('id', id)
      .single();
    if (data?.title) title = data.title;
  } catch (_) {}

  const safeTitle = escapeHtml(title);
  const safeDesc = escapeHtml(description);

  res.setHeader('Content-Type', 'text/html; charset=utf-8');
  res.status(200).send(`<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <title>${safeTitle}</title>
  <meta name="description" content="${safeDesc}">
  <meta property="og:type" content="website">
  <meta property="og:url" content="${detailUrl}">
  <meta property="og:title" content="${safeTitle}">
  <meta property="og:description" content="${safeDesc}">
  <meta name="twitter:card" content="summary">
  <meta name="twitter:title" content="${safeTitle}">
  <meta name="twitter:description" content="${safeDesc}">
  <script>window.location.replace("${flutterUrl}");</script>
</head>
<body>
  <a href="${flutterUrl}">바로가기</a>
</body>
</html>`);
};

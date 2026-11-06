<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>PDF 합치기 - 내 컴퓨터에서만</title>
<style>
  :root { --bg:#f6f5f2; --card:#fff; --ink:#1d1d1b; --muted:#6b6a66; --line:#e2e0da; --accent:#2f5d50; --warn:#a4432d; }
  * { box-sizing:border-box; }
  body { margin:0; font-family:-apple-system, "Apple SD Gothic Neo", "Malgun Gothic", "Noto Sans KR", sans-serif; background:var(--bg); color:var(--ink); }
  main { max-width:760px; margin:0 auto; padding:32px 20px 60px; }
  h1 { font-size:22px; margin:0 0 4px; }
  .sub { color:var(--muted); font-size:14px; margin:0 0 20px; }
  .drop { display:block; border:2px dashed var(--line); border-radius:14px; background:var(--card); padding:32px 16px; text-align:center; cursor:pointer; transition:.15s; }
  .drop.over { border-color:var(--accent); background:#eef4f1; }
  .drop b { display:block; font-size:16px; margin-bottom:6px; }
  .drop span { color:var(--muted); font-size:13px; }
  ul { list-style:none; padding:0; margin:18px 0; }
  li { display:flex; align-items:center; gap:10px; background:var(--card); border:1px solid var(--line); border-radius:10px; padding:10px 12px; margin-bottom:8px; }
  li.dragging { opacity:.4; }
  .num { width:26px; height:26px; border-radius:50%; background:var(--accent); color:#fff; font-size:13px; display:flex; align-items:center; justify-content:center; flex:none; }
  .info { flex:1; min-width:0; }
  .name { font-size:14px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  .meta { font-size:12px; color:var(--muted); margin-top:2px; }
  .meta.warn { color:var(--warn); }
  .pw { display:flex; gap:6px; margin-top:6px; }
  .pw input { flex:1; padding:6px 8px; border:1px solid var(--line); border-radius:6px; font-size:13px; }
  button { font:inherit; border:1px solid var(--line); background:#fff; border-radius:8px; padding:6px 10px; cursor:pointer; font-size:13px; }
  button:hover { border-color:var(--ink); }
  button:disabled { opacity:.4; cursor:default; }
  .icon { width:32px; padding:6px 0; }
  .primary { background:var(--accent); color:#fff; border-color:var(--accent); padding:12px 18px; font-size:15px; }
  .primary:hover { border-color:var(--accent); filter:brightness(1.1); }
  .bar { display:flex; gap:10px; align-items:center; flex-wrap:wrap; }
  .bar input { padding:10px; border:1px solid var(--line); border-radius:8px; font-size:14px; min-width:220px; flex:1; }
  #status { font-size:13px; color:var(--muted); margin-top:12px; min-height:18px; }
  #status.err { color:var(--warn); }
  .note { font-size:12px; color:var(--muted); margin-top:28px; line-height:1.6; border-top:1px solid var(--line); padding-top:14px; }
  .empty { text-align:center; color:var(--muted); font-size:13px; padding:8px; }
</style>
</head>
<body>
<main>
  <h1>PDF 합치기</h1>
  <p class="sub">파일은 이 컴퓨터 밖으로 나가지 않아요. 인터넷 연결 없이도 동작해요.</p>

  <label class="drop" id="drop">
    <b>PDF나 이미지를 여기에 끌어다 놓기</b>
    <span>또는 눌러서 선택 · PDF, JPG, PNG · 여러 개 가능</span>
    <input type="file" id="picker" accept="application/pdf,image/jpeg,image/png" multiple hidden>
  </label>

  <ul id="list"></ul>

  <div class="bar">
    <input id="outname" value="합본.pdf" aria-label="저장할 파일 이름">
    <button class="primary" id="merge" disabled>합치고 저장하기</button>
  </div>
  <div id="status"></div>

  <div class="note">
    · 목록 순서대로 합쳐져요. ↑↓ 버튼이나 끌어서 순서를 바꿀 수 있어요.<br>
    · 암호 걸린 PDF는 암호를 입력하면 풀린 상태로 들어가요. 이 경우 해당 페이지는 고해상도 이미지로 변환돼요(글자 선택은 안 되지만 제출용으로는 충분해요).<br>
    · 이미지(통장 사본 사진 등)는 세로 A4 한 장에 맞춰 넣어요.
  </div>
</main>

<script>__PDFLIB__</script>
<script>__PDFJS__</script>
<script id="worker-src" type="text/plain">__WORKER__</script>
<script>
(function(){
  // 실행 파일로 열었을 때: 창을 닫으면 프로그램도 종료되도록 신호 보내기
  if (location.protocol.startsWith('http')) {
    setInterval(() => fetch('/ping').catch(()=>{}), 2000);
  }
  const workerBlob = new Blob([document.getElementById('worker-src').textContent], {type:'text/javascript'});
  pdfjsLib.GlobalWorkerOptions.workerSrc = URL.createObjectURL(workerBlob);

  const items = []; // {id, file, name, kind:'pdf'|'image', bytes, pages, encrypted, password, unlocked, error}
  let uid = 0;
  const $ = id => document.getElementById(id);
  const list = $('list'), status = $('status'), mergeBtn = $('merge');

  function setStatus(msg, err){ status.textContent = msg||''; status.className = err ? 'err' : ''; }

  async function inspect(it){
    if (it.kind === 'image'){ it.pages = 1; return; }
    try {
      const doc = await pdfjsLib.getDocument({data: it.bytes.slice(), password: it.password || undefined}).promise;
      it.pages = doc.numPages; it.unlocked = true; it.error = null;
      // check if pdf-lib can read it directly (not encrypted)
      try { await PDFLib.PDFDocument.load(it.bytes); it.encrypted = !!it.password; }
      catch(e){ it.encrypted = true; }
      await doc.destroy();
    } catch(e){
      if (e && e.name === 'PasswordException'){
        it.encrypted = true; it.unlocked = false;
        it.error = it.password ? '암호가 맞지 않아요' : null;
      } else { it.error = '읽을 수 없는 파일이에요'; }
    }
  }

  async function addFiles(files){
    for (const f of files){
      const isPdf = f.type === 'application/pdf' || /\.pdf$/i.test(f.name);
      const isImg = /^image\/(jpeg|png)$/.test(f.type) || /\.(jpe?g|png)$/i.test(f.name);
      if (!isPdf && !isImg) { setStatus(f.name + ': PDF, JPG, PNG만 넣을 수 있어요', true); continue; }
      const it = {id: ++uid, name:f.name, kind: isPdf?'pdf':'image', bytes: new Uint8Array(await f.arrayBuffer()), password:''};
      if (!isPdf) it.mime = /png$/i.test(f.type || f.name) ? 'png' : 'jpg';
      items.push(it);
      await inspect(it);
    }
    render();
  }

  function render(){
    list.innerHTML = '';
    if (!items.length){ list.innerHTML = '<li class="empty">아직 추가한 파일이 없어요</li>'; }
    items.forEach((it, i) => {
      const li = document.createElement('li');
      li.draggable = true; li.dataset.i = i;
      let meta, warn = false;
      if (it.kind === 'image') meta = '이미지 · 1쪽';
      else if (it.encrypted && !it.unlocked){ meta = it.error || '암호가 걸려 있어요. 암호를 입력하세요'; warn = true; }
      else if (it.error){ meta = it.error; warn = true; }
      else meta = 'PDF · ' + it.pages + '쪽' + (it.encrypted ? ' · 암호 풀림' : '');
      li.innerHTML = `<div class="num">${i+1}</div>
        <div class="info"><div class="name"></div><div class="meta ${warn?'warn':''}"></div></div>
        <button class="icon" data-a="up" ${i===0?'disabled':''} aria-label="위로">↑</button>
        <button class="icon" data-a="down" ${i===items.length-1?'disabled':''} aria-label="아래로">↓</button>
        <button class="icon" data-a="del" aria-label="삭제">✕</button>`;
      li.querySelector('.name').textContent = it.name;
      li.querySelector('.meta').textContent = meta;
      if (it.encrypted && !it.unlocked){
        const pw = document.createElement('form'); pw.className = 'pw';
        pw.innerHTML = '<input type="password" placeholder="PDF 암호" autocomplete="off"><button>풀기</button>';
        pw.addEventListener('submit', async e => { e.preventDefault(); it.password = pw.querySelector('input').value; await inspect(it); render(); });
        li.querySelector('.info').appendChild(pw);
      }
      li.querySelectorAll('button[data-a]').forEach(b => b.addEventListener('click', e => {
        e.preventDefault();
        const a = b.dataset.a;
        if (a==='up' && i>0) [items[i-1], items[i]] = [items[i], items[i-1]];
        if (a==='down' && i<items.length-1) [items[i+1], items[i]] = [items[i], items[i+1]];
        if (a==='del') items.splice(i,1);
        render();
      }));
      li.addEventListener('dragstart', e => { li.classList.add('dragging'); e.dataTransfer.setData('text/x-idx', String(i)); });
      li.addEventListener('dragend', () => li.classList.remove('dragging'));
      li.addEventListener('dragover', e => { if (e.dataTransfer.types.includes('text/x-idx')) e.preventDefault(); });
      li.addEventListener('drop', e => {
        const from = e.dataTransfer.getData('text/x-idx'); if (from==='') return;
        e.preventDefault(); e.stopPropagation();
        const [m] = items.splice(+from, 1); items.splice(i, 0, m); render();
      });
      list.appendChild(li);
    });
    const ready = items.length > 0 && items.every(it => !it.error && (it.kind==='image' || it.unlocked));
    mergeBtn.disabled = !ready;
  }

  const A4 = [595.28, 841.89];
  async function addImagePage(out, bytes, kind){
    const img = kind==='png' ? await out.embedPng(bytes) : await out.embedJpg(bytes);
    const [W,H] = A4;
    const m = 24, s = Math.min((W-2*m)/img.width, (H-2*m)/img.height);
    const w = img.width*s, h = img.height*s;
    const p = out.addPage([W,H]);
    p.drawImage(img, {x:(W-w)/2, y:(H-h)/2, width:w, height:h});
  }

  async function rasterizePdf(out, it){
    const doc = await pdfjsLib.getDocument({data: it.bytes.slice(), password: it.password}).promise;
    for (let n=1; n<=doc.numPages; n++){
      setStatus(`${it.name}: ${n}/${doc.numPages}쪽 변환 중...`);
      const page = await doc.getPage(n);
      const base = page.getViewport({scale:1});
      const vp = page.getViewport({scale: 200/72});
      const c = document.createElement('canvas'); c.width = Math.ceil(vp.width); c.height = Math.ceil(vp.height);
      const ctx = c.getContext('2d'); ctx.fillStyle = '#fff'; ctx.fillRect(0,0,c.width,c.height);
      await page.render({canvasContext: ctx, viewport: vp}).promise;
      const jpg = await new Promise(r => c.toBlob(b => b.arrayBuffer().then(r), 'image/jpeg', 0.92));
      const img = await out.embedJpg(jpg);
      const p = out.addPage([base.width, base.height]);
      p.drawImage(img, {x:0, y:0, width:base.width, height:base.height});
    }
    await doc.destroy();
  }

  function save(bytes, name){
    const blob = new Blob([bytes], {type:'application/pdf'});
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob); a.download = name;
    document.body.appendChild(a); a.click(); a.remove();
    setTimeout(() => URL.revokeObjectURL(a.href), 60000);
  }

  mergeBtn.addEventListener('click', async () => {
    mergeBtn.disabled = true;
    try {
      const out = await PDFLib.PDFDocument.create();
      for (const it of items){
        setStatus(it.name + ' 넣는 중...');
        if (it.kind === 'image') await addImagePage(out, it.bytes, it.mime);
        else if (it.encrypted) await rasterizePdf(out, it);
        else {
          const src = await PDFLib.PDFDocument.load(it.bytes);
          const pages = await out.copyPages(src, src.getPageIndices());
          pages.forEach(p => out.addPage(p));
        }
      }
      const bytes = await out.save();
      let name = ($('outname').value || '합본.pdf').trim(); if (!/\.pdf$/i.test(name)) name += '.pdf';
      save(bytes, name);
      setStatus(`완료! 총 ${out.getPageCount()}쪽 · "${name}" 저장됨`);
      window.__lastMerged = bytes;
    } catch(e){ console.error(e); setStatus('합치는 중 문제가 생겼어요: ' + (e.message||e), true); }
    render();
  });

  const drop = $('drop'), picker = $('picker');
  picker.addEventListener('change', () => { addFiles([...picker.files]); picker.value=''; });
  drop.addEventListener('dragover', e => { if (e.dataTransfer.types.includes('Files')){ e.preventDefault(); drop.classList.add('over'); }});
  drop.addEventListener('dragleave', () => drop.classList.remove('over'));
  drop.addEventListener('drop', e => { e.preventDefault(); drop.classList.remove('over'); addFiles([...e.dataTransfer.files]); });
  document.addEventListener('dragover', e => { if (e.dataTransfer.types.includes('Files')) e.preventDefault(); });
  document.addEventListener('drop', e => { if (e.dataTransfer.types.includes('Files') && !drop.contains(e.target)) { e.preventDefault(); addFiles([...e.dataTransfer.files]); }});

  window.__addFiles = addFiles; window.__items = items;
  render();
})();
</script>
</body>
</html>

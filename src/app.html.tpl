<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>PDF 합치기</title>
<style>
  :root{
    --bg:#F2F4F6; --card:#FFFFFF; --ink:#191F28; --sub:#4E5968; --muted:#8B95A1; --line:#E5E8EB; --fill:#F9FAFB;
    --primary:#3182F6; --primary-press:#1B64DA; --primary-soft:#E8F3FF; --danger:#F04452;
    --radius:16px; --ease:cubic-bezier(.2,.8,.2,1);
  }
  *{box-sizing:border-box}
  html,body{margin:0;height:100%}
  body{background:var(--bg);color:var(--ink);font-family:Pretendard,"Pretendard Variable",-apple-system,BlinkMacSystemFont,"Apple SD Gothic Neo","Malgun Gothic","Noto Sans KR",sans-serif;-webkit-font-smoothing:antialiased;letter-spacing:-0.01em}
  button{font:inherit;color:inherit;cursor:pointer;border:0;background:none}
  button:disabled{cursor:default}
  .wrap{max-width:1080px;margin:0 auto;padding:40px 24px 140px}

  /* header */
  header{display:flex;align-items:flex-end;justify-content:space-between;gap:16px;margin-bottom:24px}
  h1{font-size:26px;font-weight:700;margin:0 0 6px}
  .lead{margin:0;color:var(--sub);font-size:15px;display:flex;align-items:center;gap:6px}
  .lead svg{color:var(--primary);flex:none}
  .btn{height:44px;padding:0 18px;border-radius:12px;font-size:15px;font-weight:600;display:inline-flex;align-items:center;gap:6px;transition:background .15s var(--ease),transform .1s var(--ease)}
  .btn:active:not(:disabled){transform:scale(.97)}
  .btn-secondary{background:var(--primary-soft);color:var(--primary)}
  .btn-secondary:hover{background:#D6E9FF}
  .btn-primary{background:var(--primary);color:#fff;min-width:148px;justify-content:center}
  .btn-primary:hover:not(:disabled){background:var(--primary-press)}
  .btn-primary:disabled{background:#B9D7FC}

  /* empty state */
  .empty{background:var(--card);border-radius:24px;padding:72px 24px;text-align:center;border:2px dashed transparent;transition:border-color .15s var(--ease),background .15s var(--ease);cursor:pointer}
  .empty:hover{border-color:var(--line)}
  .empty .ico{width:64px;height:64px;border-radius:20px;background:var(--primary-soft);color:var(--primary);display:grid;place-items:center;margin:0 auto 20px}
  .empty b{display:block;font-size:19px;margin-bottom:8px}
  .empty p{margin:0;color:var(--muted);font-size:14px;line-height:1.6}

  /* file chips */
  .files{display:flex;flex-wrap:wrap;gap:8px;margin-bottom:20px}
  .chip{display:inline-flex;align-items:center;gap:8px;height:36px;padding:0 6px 0 12px;background:var(--card);border-radius:999px;font-size:13px;color:var(--sub);max-width:320px}
  .chip .dot{width:8px;height:8px;border-radius:50%;flex:none}
  .chip .nm{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
  .chip .ct{color:var(--muted);flex:none}
  .chip .x{width:24px;height:24px;border-radius:50%;display:grid;place-items:center;color:var(--muted);flex:none}
  .chip .x:hover{background:var(--fill);color:var(--ink)}
  .chip.locked{background:#FFF4E6;color:#B25E09}
  .chip.locked .unlock{font-weight:600;color:#B25E09;text-decoration:underline;text-underline-offset:2px;padding:0 4px}
  .chip.error{background:#FFEEEE;color:var(--danger)}

  /* page grid */
  .hint{font-size:13px;color:var(--muted);margin:0 0 12px}
  .grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(156px,1fr));gap:16px}
  .page{background:var(--card);border-radius:var(--radius);padding:10px;position:relative;cursor:grab;user-select:none;transition:box-shadow .2s var(--ease)}
  .page:hover{box-shadow:0 4px 16px rgba(0,27,55,.08)}
  .page.enter{animation:enter .35s var(--ease) both}
  @keyframes enter{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:none}}
  .thumb{aspect-ratio:1/1.414;border-radius:10px;background:var(--fill);display:grid;place-items:center;overflow:hidden}
  .thumb img{max-width:100%;max-height:100%;display:block;box-shadow:0 0 0 1px var(--line);transition:transform .25s var(--ease)}
  .thumb.rot90 img,.thumb.rot270 img{max-width:70.7%}
  .skeleton{width:100%;height:100%;background:linear-gradient(90deg,#EEF0F3 25%,#F7F8FA 50%,#EEF0F3 75%);background-size:200% 100%;animation:shimmer 1.2s linear infinite}
  @keyframes shimmer{from{background-position:200% 0}to{background-position:-200% 0}}
  .badge{min-width:24px;height:22px;padding:0 7px;border-radius:999px;background:var(--ink);color:#fff;font-size:12px;font-weight:700;display:grid;place-items:center;flex:none}
  .acts{position:absolute;top:14px;right:14px;display:flex;gap:4px;opacity:0;transition:opacity .15s var(--ease)}
  .page:hover .acts,.page:focus-within .acts{opacity:1}
  .act{width:32px;height:32px;border-radius:10px;background:rgba(255,255,255,.95);box-shadow:0 1px 4px rgba(0,27,55,.12);display:grid;place-items:center;color:var(--sub)}
  .act:hover{color:var(--ink)}
  .act.del:hover{color:var(--danger)}
  .cap{display:flex;align-items:center;gap:8px;margin-top:10px;font-size:12px;color:var(--muted);padding:0 2px}
  .cap .dot{width:6px;height:6px;border-radius:50%;flex:none}
  .cap .nm{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;flex:1}
  .ghost{opacity:.35}
  .chosen{box-shadow:0 12px 32px rgba(0,27,55,.18)!important}

  /* bottom bar */
  .bar{position:fixed;left:0;right:0;bottom:0;background:rgba(255,255,255,.96);border-top:1px solid var(--line);transform:translateY(100%);transition:transform .3s var(--ease)}
  .bar.show{transform:none}
  .bar .in{max-width:1080px;margin:0 auto;padding:14px 24px;display:flex;align-items:center;gap:12px}
  .sum{font-size:14px;color:var(--sub);flex:none}
  .sum b{color:var(--ink)}
  .name{flex:1;display:flex;align-items:center;height:44px;background:var(--fill);border-radius:12px;padding:0 14px;border:1px solid transparent}
  .name:focus-within{border-color:var(--primary);background:#fff}
  .name input{flex:1;border:0;background:none;font:inherit;font-size:15px;outline:none;min-width:0;color:var(--ink)}
  .name span{color:var(--muted);font-size:15px}
  .warn{font-size:13px;color:#B25E09}
  .spin{width:18px;height:18px;border-radius:50%;border:2.5px solid rgba(255,255,255,.4);border-top-color:#fff;animation:spin .7s linear infinite}
  @keyframes spin{to{transform:rotate(360deg)}}

  /* toast */
  .toast{position:fixed;left:50%;bottom:96px;transform:translate(-50%,12px);opacity:0;pointer-events:none;background:#333D4B;color:#fff;border-radius:999px;padding:12px 20px;font-size:14px;display:flex;align-items:center;gap:14px;transition:opacity .2s var(--ease),transform .2s var(--ease);white-space:nowrap}
  .toast.show{opacity:1;transform:translate(-50%,0);pointer-events:auto}
  .toast button{color:#64A8FF;font-weight:600}

  /* modal */
  .scrim{position:fixed;inset:0;background:rgba(0,0,0,.4);display:grid;place-items:center;opacity:0;pointer-events:none;transition:opacity .2s var(--ease)}
  .scrim.show{opacity:1;pointer-events:auto}
  .modal{background:#fff;border-radius:24px;width:min(400px,calc(100% - 40px));padding:28px 24px 20px;transform:scale(.96);transition:transform .2s var(--ease)}
  .scrim.show .modal{transform:none}
  .modal h2{font-size:20px;margin:0 0 8px}
  .modal p{margin:0 0 20px;color:var(--sub);font-size:14px;line-height:1.5;word-break:keep-all}
  .modal p b{color:var(--ink);font-weight:600}
  .field{height:52px;border-radius:14px;background:var(--fill);border:1px solid var(--line);display:flex;align-items:center;padding:0 16px}
  .field.err{border-color:var(--danger)}
  .field input{flex:1;border:0;background:none;font:inherit;font-size:16px;outline:none}
  .err-msg{color:var(--danger);font-size:13px;margin:8px 2px 0;min-height:18px}
  .modal .row{display:flex;gap:8px;margin-top:16px}
  .modal .row .btn{flex:1;justify-content:center;height:52px;border-radius:14px}
  .btn-ghost{background:var(--fill);color:var(--sub)}
  .btn-ghost:hover{background:var(--line)}

  /* window drop overlay */
  .drop-ov{position:fixed;inset:12px;border-radius:24px;border:2px dashed var(--primary);background:rgba(232,243,255,.85);display:grid;place-items:center;font-size:18px;font-weight:700;color:var(--primary);opacity:0;pointer-events:none;transition:opacity .15s var(--ease)}
  .drop-ov.show{opacity:1}
  @media (max-width:640px){ header{flex-direction:column;align-items:stretch} .bar .in{flex-wrap:wrap} .sum{width:100%} }
  @media (prefers-reduced-motion:reduce){ *{animation:none!important;transition:none!important} }
</style>
</head>
<body>
<div class="wrap">
  <header>
    <div>
      <h1>PDF 합치기</h1>
      <p class="lead">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>
        파일은 이 컴퓨터 밖으로 나가지 않아요
      </p>
    </div>
    <button class="btn btn-secondary" id="addBtn" hidden>
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg>
      파일 추가
    </button>
  </header>

  <div class="empty" id="empty" role="button" tabindex="0">
    <div class="ico"><svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z"/><path d="M14 3v5h5M12 18v-6M9 15h6"/></svg></div>
    <b>PDF나 사진을 끌어다 놓으세요</b>
    <p>눌러서 고를 수도 있어요 · PDF, JPG, PNG<br>넣은 파일의 모든 페이지를 원하는 순서로 섞을 수 있어요</p>
  </div>

  <section id="work" hidden>
    <div class="files" id="files"></div>
    <p class="hint">페이지를 끌어서 순서를 바꾸세요. 다른 파일의 페이지와도 섞을 수 있어요.</p>
    <div class="grid" id="grid"></div>
  </section>
</div>

<div class="bar" id="bar">
  <div class="in">
    <div class="sum" id="sum"></div>
    <label class="name"><input id="outname" value="합본" aria-label="저장할 파일 이름" spellcheck="false"><span>.pdf</span></label>
    <span class="warn" id="warn" hidden></span>
    <button class="btn btn-primary" id="saveBtn">PDF로 저장</button>
  </div>
</div>

<div class="toast" id="toast" role="status"><span id="toastMsg"></span><button id="toastAct" hidden>되돌리기</button></div>

<div class="scrim" id="scrim">
  <form class="modal" id="pwForm" autocomplete="off">
    <h2>암호를 입력해 주세요</h2>
    <p><b id="pwName"></b> 파일에 암호가 걸려 있어요. 암호를 입력하면 풀린 상태로 합쳐요.</p>
    <div class="field" id="pwField"><input type="password" id="pwInput" placeholder="PDF 암호"></div>
    <div class="err-msg" id="pwErr"></div>
    <div class="row">
      <button type="button" class="btn btn-ghost" id="pwLater">나중에</button>
      <button type="submit" class="btn btn-primary">확인</button>
    </div>
  </form>
</div>

<div class="drop-ov" id="dropOv">여기에 놓으면 추가돼요</div>
<input type="file" id="picker" accept="application/pdf,image/jpeg,image/png" multiple hidden>

<script>__PDFLIB__</script>
<script>__PDFJS__</script>
<script>__SORTABLE__</script>
<script id="worker-src" type="text/plain">__WORKER__</script>
<script>
(function(){
  if (location.protocol.startsWith('http')) setInterval(() => fetch('/ping').catch(()=>{}), 2000);
  pdfjsLib.GlobalWorkerOptions.workerSrc = URL.createObjectURL(new Blob([document.getElementById('worker-src').textContent], {type:'text/javascript'}));

  const $ = id => document.getElementById(id);
  const COLORS = ['#3182F6','#00B386','#FF8A00','#8B5CF6','#06B6D4','#F25291'];
  const files = new Map();   // fid -> {id,name,kind,bytes,mime,color,state:'ready'|'locked'|'error',raster,doc,numPages}
  let pages = [];            // {pid,fid,index,rot,thumb}
  let fseq = 0, pseq = 0, colorIdx = 0, busy = false;
  const pwQueue = [];

  const ICON_ROT = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12a9 9 0 1 1-3-6.7L21 8"/><path d="M21 3v5h-5"/></svg>';
  const ICON_DEL = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3"/></svg>';
  const ICON_X = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round"><path d="M6 6l12 12M18 6L6 18"/></svg>';

  /* ---------- toast ---------- */
  let toastTimer;
  function toast(msg, action){
    $('toastMsg').textContent = msg;
    const b = $('toastAct'); b.hidden = !action; b.onclick = action ? () => { action(); hideToast(); } : null;
    $('toast').classList.add('show');
    clearTimeout(toastTimer); toastTimer = setTimeout(hideToast, action ? 5000 : 2500);
  }
  function hideToast(){ $('toast').classList.remove('show'); }

  /* ---------- loading files ---------- */
  async function openPdf(f, password){
    const doc = await pdfjsLib.getDocument({data: f.bytes.slice(), password: password || undefined}).promise;
    f.doc = doc; f.numPages = doc.numPages; f.state = 'ready';
    try { await PDFLib.PDFDocument.load(f.bytes); f.raster = false; } catch(e){ f.raster = true; }
    const added = [];
    for (let i=0;i<doc.numPages;i++){ const p = {pid:++pseq, fid:f.id, index:i, rot:0, thumb:null, fresh:true}; pages.push(p); added.push(p); }
    return added;
  }

  async function addFiles(list){
    let firstAdd = true;
    for (const file of list){
      const isPdf = file.type === 'application/pdf' || /\.pdf$/i.test(file.name);
      const isImg = /^image\/(jpeg|png)$/.test(file.type) || /\.(jpe?g|png)$/i.test(file.name);
      if (!isPdf && !isImg){ toast('PDF, JPG, PNG만 넣을 수 있어요'); continue; }
      const f = {id:++fseq, name:file.name, kind:isPdf?'pdf':'image', bytes:new Uint8Array(await file.arrayBuffer()), color:COLORS[colorIdx++ % COLORS.length], state:'ready'};
      files.set(f.id, f);
      if (isImg){
        f.mime = /png/i.test(file.type || file.name) ? 'png' : 'jpg';
        f.numPages = 1;
        const p = {pid:++pseq, fid:f.id, index:0, rot:0, thumb:URL.createObjectURL(new Blob([f.bytes],{type:'image/'+(f.mime==='png'?'png':'jpeg')})), fresh:true};
        pages.push(p);
      } else {
        try { await openPdf(f); }
        catch(e){
          if (e && e.name === 'PasswordException'){ f.state = 'locked'; pwQueue.push(f.id); }
          else f.state = 'error';
        }
      }
      render();
    }
    nextPassword();
  }

  /* ---------- password modal ---------- */
  let pwFid = null;
  function nextPassword(){
    if (pwFid !== null) return;
    while (pwQueue.length){
      const id = pwQueue.shift(); const f = files.get(id);
      if (f && f.state === 'locked'){ askPassword(id); return; }
    }
  }
  function askPassword(id){
    pwFid = id; const f = files.get(id);
    $('pwName').textContent = f.name; $('pwInput').value = ''; $('pwErr').textContent = ''; $('pwField').classList.remove('err');
    $('scrim').classList.add('show'); setTimeout(() => $('pwInput').focus(), 50);
  }
  function closePassword(){ $('scrim').classList.remove('show'); pwFid = null; nextPassword(); }
  $('pwForm').addEventListener('submit', async e => {
    e.preventDefault();
    const f = files.get(pwFid); if (!f) return closePassword();
    try { await openPdf(f, $('pwInput').value); closePassword(); render(); toast('암호를 풀었어요'); }
    catch(err){
      if (err && err.name === 'PasswordException'){ $('pwErr').textContent = '암호가 맞지 않아요. 다시 확인해 주세요'; $('pwField').classList.add('err'); $('pwInput').select(); }
      else { f.state = 'error'; closePassword(); render(); }
    }
  });
  $('pwLater').addEventListener('click', closePassword);
  $('pwInput').addEventListener('input', () => { $('pwErr').textContent=''; $('pwField').classList.remove('err'); });
  document.addEventListener('keydown', e => { if (e.key === 'Escape' && pwFid !== null) closePassword(); });

  /* ---------- thumbnails ---------- */
  const thumbQueue = []; let thumbRunning = false;
  function queueThumb(p){ if (!p.thumb && !p.queued){ p.queued = true; thumbQueue.push(p); runThumbs(); } }
  async function runThumbs(){
    if (thumbRunning) return; thumbRunning = true;
    while (thumbQueue.length){
      const p = thumbQueue.shift(); const f = files.get(p.fid);
      if (!f || !f.doc) continue;
      try {
        const pg = await f.doc.getPage(p.index+1);
        const v1 = pg.getViewport({scale:1}); const vp = pg.getViewport({scale: 320 / Math.max(v1.width, v1.height)});
        const c = document.createElement('canvas'); c.width = Math.ceil(vp.width); c.height = Math.ceil(vp.height);
        const ctx = c.getContext('2d'); ctx.fillStyle='#fff'; ctx.fillRect(0,0,c.width,c.height);
        await pg.render({canvasContext:ctx, viewport:vp}).promise;
        p.thumb = c.toDataURL('image/jpeg', .85);
        const el = document.querySelector(`.page[data-pid="${p.pid}"] .thumb`);
        if (el) el.innerHTML = `<img alt="" src="${p.thumb}" style="transform:rotate(${p.rot}deg)">`;
      } catch(e){ console.error(e); }
    }
    thumbRunning = false;
  }

  /* ---------- render ---------- */
  function render(){
    const has = files.size > 0;
    $('empty').hidden = has; $('work').hidden = !has; $('addBtn').hidden = !has;
    $('bar').classList.toggle('show', has);

    // file chips
    const fc = $('files'); fc.innerHTML = '';
    for (const f of files.values()){
      const ch = document.createElement('div');
      ch.className = 'chip' + (f.state==='locked' ? ' locked' : f.state==='error' ? ' error' : '');
      const cnt = f.state==='ready' ? `${pages.filter(p=>p.fid===f.id).length}쪽` : f.state==='locked' ? '' : '열 수 없는 파일';
      ch.innerHTML = `<span class="dot" style="background:${f.color}"></span><span class="nm"></span><span class="ct">${cnt}</span>`
        + (f.state==='locked' ? '<button class="unlock">암호 입력</button>' : '')
        + `<button class="x" aria-label="파일 빼기" title="파일 빼기">${ICON_X}</button>`;
      ch.querySelector('.nm').textContent = f.name;
      ch.querySelector('.x').onclick = () => removeFile(f.id);
      const u = ch.querySelector('.unlock'); if (u) u.onclick = () => askPassword(f.id);
      fc.appendChild(ch);
    }

    // pages
    const grid = $('grid'); grid.innerHTML = '';
    let stagger = 0;
    pages.forEach((p, i) => {
      const f = files.get(p.fid);
      const el = document.createElement('div');
      el.className = 'page' + (p.fresh ? ' enter' : ''); el.dataset.pid = p.pid;
      if (p.fresh){ el.style.animationDelay = Math.min(stagger++, 12) * 30 + 'ms'; p.fresh = false; }
      const r = ((p.rot % 360) + 360) % 360;
      el.innerHTML = `<div class="thumb rot${r}">${p.thumb ? `<img alt="" src="${p.thumb}" style="transform:rotate(${p.rot}deg)">` : '<div class="skeleton"></div>'}</div>
        <div class="acts">
          <button class="act" data-a="rot" title="오른쪽으로 돌리기" aria-label="오른쪽으로 돌리기">${ICON_ROT}</button>
          <button class="act del" data-a="del" title="이 페이지 빼기" aria-label="이 페이지 빼기">${ICON_DEL}</button>
        </div>
        <div class="cap"><span class="badge">${i+1}</span><span class="dot" style="background:${f.color}"></span><span class="nm"></span><span>${f.numPages>1 ? (p.index+1)+'쪽' : ''}</span></div>`;
      el.querySelector('.cap .nm').textContent = f.name.replace(/\.[^.]+$/, '');
      el.querySelector('[data-a=rot]').onclick = () => rotate(p.pid);
      el.querySelector('[data-a=del]').onclick = () => removePage(p.pid);
      grid.appendChild(el);
      if (!p.thumb) queueThumb(p);
    });
    updateBar();
  }

  function renumber(){ document.querySelectorAll('#grid .page').forEach((el,i) => el.querySelector('.badge').textContent = i+1); }

  function updateBar(){
    const ready = [...files.values()].filter(f=>f.state==='ready').length;
    $('sum').innerHTML = `<b>${pages.length}쪽</b> · 파일 ${ready}개`;
    const locked = [...files.values()].some(f=>f.state==='locked');
    $('warn').hidden = !locked; $('warn').textContent = locked ? '암호를 입력하지 않은 파일은 빠져요' : '';
    if (!busy) $('saveBtn').disabled = pages.length === 0;
  }

  /* ---------- actions ---------- */
  function rotate(pid){
    const p = pages.find(x=>x.pid===pid); p.rot = (p.rot + 90);
    const th = document.querySelector(`.page[data-pid="${pid}"] .thumb`);
    th.className = 'thumb rot' + (p.rot % 360);
    const img = th.querySelector('img'); if (img) img.style.transform = `rotate(${p.rot}deg)`;
  }
  function removePage(pid){
    const i = pages.findIndex(x=>x.pid===pid); const [p] = pages.splice(i,1);
    render();
    toast(`${i+1}쪽을 뺐어요`, () => { pages.splice(Math.min(i,pages.length),0,p); render(); });
  }
  function removeFile(fid){
    const f = files.get(fid);
    const snapshot = pages.slice();
    pages = pages.filter(p=>p.fid!==fid); files.delete(fid);
    render();
    toast(`${f.name}을(를) 뺐어요`, () => { files.set(fid,f); pages = snapshot; render(); });
  }

  new Sortable($('grid'), {
    animation: 220, easing: 'cubic-bezier(.2,.8,.2,1)',
    ghostClass: 'ghost', chosenClass: 'chosen', filter: '.act', preventOnFilter: false,
    onEnd(){
      const order = [...$('grid').children].map(el => +el.dataset.pid);
      pages.sort((a,b) => order.indexOf(a.pid) - order.indexOf(b.pid));
      renumber();
    }
  });

  /* ---------- save ---------- */
  const A4 = [595.28, 841.89];
  async function build(progress){
    const {PDFDocument, degrees} = PDFLib;
    const out = await PDFDocument.create();
    const srcCache = new Map(), imgCache = new Map();
    let n = 0;
    for (const p of pages){
      progress(++n, pages.length);
      const f = files.get(p.fid);
      const rot = ((p.rot % 360) + 360) % 360;
      if (f.kind === 'image'){
        let img = imgCache.get(f.id);
        if (!img){ img = f.mime==='png' ? await out.embedPng(f.bytes) : await out.embedJpg(f.bytes); imgCache.set(f.id, img); }
        const [W,H] = A4, m = 28, s = Math.min((W-2*m)/img.width, (H-2*m)/img.height);
        const page = out.addPage([W,H]);
        page.drawImage(img, {x:(W-img.width*s)/2, y:(H-img.height*s)/2, width:img.width*s, height:img.height*s});
        if (rot) page.setRotation(degrees(rot));
      } else if (f.raster){
        const pg = await f.doc.getPage(p.index+1);
        const base = pg.getViewport({scale:1}), vp = pg.getViewport({scale:200/72});
        const c = document.createElement('canvas'); c.width = Math.ceil(vp.width); c.height = Math.ceil(vp.height);
        const ctx = c.getContext('2d'); ctx.fillStyle='#fff'; ctx.fillRect(0,0,c.width,c.height);
        await pg.render({canvasContext:ctx, viewport:vp}).promise;
        const jpg = await new Promise(r => c.toBlob(b => b.arrayBuffer().then(r), 'image/jpeg', .92));
        const img = await out.embedJpg(jpg);
        const page = out.addPage([base.width, base.height]);
        page.drawImage(img, {x:0, y:0, width:base.width, height:base.height});
        if (rot) page.setRotation(degrees(rot));
      } else {
        let src = srcCache.get(f.id);
        if (!src){ src = await PDFDocument.load(f.bytes); srcCache.set(f.id, src); }
        const [cp] = await out.copyPages(src, [p.index]);
        if (rot) cp.setRotation(degrees((cp.getRotation().angle + rot) % 360));
        out.addPage(cp);
      }
    }
    return out.save();
  }

  $('saveBtn').addEventListener('click', async () => {
    if (busy || !pages.length) return;
    busy = true; const btn = $('saveBtn'); btn.disabled = true;
    btn.innerHTML = '<span class="spin"></span><span id="prog">만드는 중</span>';
    try {
      const bytes = await build((i,t) => { const el = $('prog'); if (el) el.textContent = `${i}/${t}쪽`; });
      let name = ($('outname').value.trim() || '합본').replace(/\.pdf$/i,'') + '.pdf';
      const a = document.createElement('a');
      a.href = URL.createObjectURL(new Blob([bytes], {type:'application/pdf'})); a.download = name;
      document.body.appendChild(a); a.click(); a.remove();
      setTimeout(() => URL.revokeObjectURL(a.href), 60000);
      window.__lastBytes = bytes;
      toast(`${name}을(를) 저장했어요`);
    } catch(e){ console.error(e); toast('저장하지 못했어요. 파일을 다시 확인해 주세요'); }
    busy = false; btn.textContent = 'PDF로 저장'; updateBar();
  });

  /* ---------- input ---------- */
  const picker = $('picker');
  $('empty').addEventListener('click', () => picker.click());
  $('empty').addEventListener('keydown', e => { if (e.key==='Enter'||e.key===' '){ e.preventDefault(); picker.click(); }});
  $('addBtn').addEventListener('click', () => picker.click());
  picker.addEventListener('change', () => { addFiles([...picker.files]); picker.value=''; });
  let dragDepth = 0;
  const isFiles = e => e.dataTransfer && [...e.dataTransfer.types].includes('Files');
  window.addEventListener('dragenter', e => { if (isFiles(e)){ dragDepth++; $('dropOv').classList.add('show'); }});
  window.addEventListener('dragleave', e => { if (isFiles(e) && --dragDepth <= 0){ dragDepth=0; $('dropOv').classList.remove('show'); }});
  window.addEventListener('dragover', e => { if (isFiles(e)) e.preventDefault(); });
  window.addEventListener('drop', e => { if (!isFiles(e)) return; e.preventDefault(); dragDepth=0; $('dropOv').classList.remove('show'); addFiles([...e.dataTransfer.files]); });

  // test hooks
  window.__app = { addFiles, get pages(){ return pages; }, files, move(from,to){ const [p]=pages.splice(from,1); pages.splice(to,0,p); render(); } };
  render();
})();
</script>
</body>
</html>

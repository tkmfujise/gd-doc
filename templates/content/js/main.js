function toggleElementClass(elem, class_name) {
  if (elem.classList.contains(class_name)) {
    elem.classList.remove(class_name)
  }
  else {
    elem.classList.add(class_name)
  }
}

function toggleContentsMenu() {
  const elem = document.querySelector('aside.contents-menu')
  if (!elem) return;
  toggleElementClass(elem, 'open')
}


function openContentsMenu() {
  const elem = document.querySelector('aside.contents-menu')
  if (!elem) return;
  elem.classList.add('open')
}


function hideContentsMenu() {
  const elem = document.querySelector('aside.contents-menu')
  if (!elem) return;
  elem.classList.remove('open')
}


function toggleTocContents() {
  const elem = document.querySelector('#toc .sectlevel1')
  if (!elem) return;
  toggleElementClass(elem, 'open')
}


function base64UrlDecode(str) {
  str = str.replace(/-/g, '+').replace(/_/g, '/');
  while (str.length % 4 !== 0) {
    str += '=';
  }
  return atob(str);
}


function searchPath(path) {
  const elem = document.querySelector('.contents-menu .search-form input[type="search"]')
  if (elem) {
    openContentsMenu()
    elem.value = `res://${path}`
    elem.dispatchEvent(new Event('input'))
  }
}

function searchFromFileTree(event) {
  event.stopPropagation()
  const head = event.target.closest('tr').querySelector('.path')
  if (head) {
    const pathClass = Array.from(head.classList).find(e => e != 'path')
    if (pathClass) {
      const path = base64UrlDecode(pathClass)
      searchPath(path)
    }
  }
}


window.onload = () => {
  document.querySelectorAll('.toggle-contents-menu').forEach(elem => {
    elem.addEventListener('click', toggleContentsMenu)
  })

  const article = document.querySelector('article.content')
  if (article) {
    article.addEventListener('click', hideContentsMenu)
  }

  const toctitle = document.querySelector('#toc #toctitle')
  if (toctitle) toctitle.addEventListener('click', toggleTocContents)

  document.querySelectorAll('#toc .sectlevel1 a').forEach(elem => {
    elem.addEventListener('click', toggleTocContents)
  })

  document.querySelectorAll('table.file-tree.grid tbody .one, table.file-tree.grid tbody .more').forEach(elem => {
    elem.addEventListener('click', searchFromFileTree)
  })
}

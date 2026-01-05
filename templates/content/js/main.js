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
}

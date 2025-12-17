function toggleContentsMenu() {
  const elem = document.querySelector('aside.contents-menu')
  if (!elem) return;

  if (elem.classList.contains('open')) {
    elem.classList.remove('open')
  }
  else {
    elem.classList.add('open')
  }
}


function hideContentsMenu() {
  const elem = document.querySelector('aside.contents-menu')
  if (!elem) return;
  elem.classList.remove('open')
}


window.onload = () => {
  document.querySelectorAll('.toggle-contents-menu').forEach(elem => {
    elem.addEventListener('click', toggleContentsMenu)    
  })

  const article = document.querySelector('article.content')
  if (article) {
    article.addEventListener('click', hideContentsMenu)
  }
}

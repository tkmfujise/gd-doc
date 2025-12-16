function toggleContentsMenu() {
  const elem = document.querySelector('aside.contents-menu')
  if (!elem) return;

  if (!elem.style.visibility || elem.style.visibility === 'hidden') {
    elem.style.visibility = 'visible'
  }
  else {
    elem.style.visibility = 'hidden'
  }
}



window.onload = () => {
  document.querySelectorAll('.toggle-contents-menu').forEach(elem => {
    elem.addEventListener('click', toggleContentsMenu)    
  })
}

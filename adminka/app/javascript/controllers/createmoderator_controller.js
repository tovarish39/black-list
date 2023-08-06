import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    ///////////////////////////////////////// create
    const create_moderator_button = document.querySelector('.show-modal-create-moderator')
    const modal_create_moderator = document.querySelector('.modal-create-moderator_wrap')
    const close_modal_create_moderator_img = document.querySelector('.modal-create-moderator__close-img')
    const close_modal_create_moderator_button = document.querySelector('.modal-create-moderator__close-button')
    const closes_modal_create_moderator = [close_modal_create_moderator_img, close_modal_create_moderator_button]
    const form_create_moderator = document.querySelector('.modal-create-moderator__window')

    create_moderator_button.addEventListener('click', () => {
      modal_create_moderator.classList.add('modal-create-moderator_wrap_active')
    })
    closes_modal_create_moderator.forEach((close_button) => {
      close_button.addEventListener('click', () => {
        modal_create_moderator.classList.remove('modal-create-moderator_wrap_active')
      })
    })

    form_create_moderator.addEventListener('submit', async (e) => {
      e.preventDefault()
      const inputElement = e.target.querySelector('input')
      const inputValue = inputElement.value

      async function creating(inputValue) {
        const body = { telegram_id: inputValue }
        const csrfToken = document.querySelector("[name='csrf-token']").content

        await fetch(`/moderators`, {
          method: 'POST',
          body: JSON.stringify(body),
          mode: 'cors', // no-cors, *cors, same-origin
          cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
          credentials: 'same-origin', // include, *same-origin, omit
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken,
          },
        })
      }

      document.querySelector('.blanket').classList.add('blanket_loading')
      await creating(inputValue) // Пример асинхронной обработки (замените на вашу логику)
      document.querySelector('.blanket').classList.remove('blanket_loading')

      window.location.reload()
    })
  }
}

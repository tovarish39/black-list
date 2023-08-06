import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    const all_user_elements = document.querySelectorAll('.moderators__row_item')
    const checkbox_general = document.querySelector('.users__cell-checkbox_general')
    const checkboxes_local = document.querySelectorAll('.users__cell-checkbox_local')
    const show_modal_button = document.querySelector('.users__show-modal-button')
    const search_input = document.querySelector('.search-input')

    search_input.addEventListener('input', (e) => {
      const intput_value = e.target.value
      view_users_by_options(intput_value)
    })

    /////////////////////////////////////////checkboxes
    let checked_ids = {}

    const handle_all_local = ({ checked }) => {
      checkboxes_local.forEach((local) => {
        const is_hidden_row = local.parentElement.parentElement.parentElement.classList.contains('moderators__row_none')
        if (!is_hidden_row) {
          if (checked) {
            if (!local.checked) local.click()
          } else if (!checked) {
            if (local.checked) local.click()
          }
        }
      })
    }

    checkbox_general.addEventListener('change', (e) => {
      const is_checked_general = e.target.checked
      handle_all_local({ checked: is_checked_general })
    })

    const listener_local_checkbox = (e) => {
      const is_checked = e.target.checked
      const user_id = e.target.id
      checked_ids = { ...checked_ids, ...{ [user_id]: is_checked } }
      const is_any_checked = Object.values(checked_ids).some((value) => value === true)
      is_any_checked
        ? show_modal_button.classList.add('users__show-modal-button_active')
        : show_modal_button.classList.remove('users__show-modal-button_active')
    }

    checkboxes_local.forEach((local) => {
      local.addEventListener('change', listener_local_checkbox)
    })

    function uncheck_all_checkboxes() {
      if (checkbox_general.checked) {
        checkbox_general.click()
      } else {
        checkbox_general.click()
        checkbox_general.click()
      }
    }

    /////////////////////////////// change state
    ////////////////////////////////// view_users

    function view_users_by_options(search_value) {
      // скрыть все элементы
      all_user_elements.forEach((user_element) => user_element.classList.add('moderators__row_none'))
      // расчекать все чекбоксы
      uncheck_all_checkboxes()

      all_user_elements.forEach((user_element) => {
        const dataString = user_element.getAttribute('data') // Получаем значение атрибута data
        const userData = JSON.parse(dataString)
        // const is_in_current_lg = userData['lg'] === lg

        const regex = new RegExp('^' + search_value, 'i')
        const is_in_current_search_value = regex.test(userData['telegram_id']) || regex.test(userData['username'])

        if (is_in_current_search_value) {
          user_element.classList.remove('moderators__row_none')
        }
      })
    }

    ///////////////////////// modal
    const modal_send_message = document.querySelector('.modal-send-message_wrap')
    const close_img = document.querySelector('.modal-send-message__close-img')
    const close_button = document.querySelector('.modal-send-message__close-button')
    const closes = [close_img, close_button]
    const form_message = document.querySelector('.modal-send-message__window')

    closes.forEach((element) => {
      element.addEventListener('click', () => {
        modal_send_message.classList.remove('modal-send-message_wrap_active')
      })
    })

    show_modal_button.addEventListener('click', () => {
      if (show_modal_button.classList.contains('users__show-modal-button_active')) {
        modal_send_message.classList.add('modal-send-message_wrap_active')
      }
    })

    form_message.addEventListener('submit', async (e) => {
      e.preventDefault()
      const inputElement = e.target.querySelector('textarea')
      const inputValue = inputElement.value

      async function send_message(checked_ids, inputValue) {
        const body = { checked_ids: checked_ids, inputValue: inputValue }
        const csrfToken = document.querySelector("[name='csrf-token']").content

        await fetch(`/moderators/send_message`, {
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
      await send_message(checked_ids, inputValue) // Пример асинхронной обработки (замените на вашу логику)
      document.querySelector('.blanket').classList.remove('blanket_loading')
      uncheck_all_checkboxes()

      inputElement.value = ''
      modal_send_message.classList.remove('modal-send-message_wrap_active')
    })
  }
}

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

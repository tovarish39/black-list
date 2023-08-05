import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    // let checked_ids = {}
    // const checkbox_general = document.querySelector('.users__cell-checkbox_general')
    // const checkboxes_local = document.querySelectorAll('.users__cell-checkbox_local')
    // const show_modal_button = document.querySelector('.users__show-modal-button')
    // const handle_all_local = ({ checked }) => {
    //   checkboxes_local.forEach((local) => {
    //     if (checked) {
    //       if (!local.checked) local.click()
    //     } else if (!checked) {
    //       if (local.checked) local.click()
    //     }
    //   })
    // }
    // checkbox_general.addEventListener('change', (e) => {
    //   const is_checked_general = e.target.checked
    //   handle_all_local({ checked: is_checked_general })
    // })
    // const listener_local_checkbox = (e) => {
    //   const is_checked = e.target.checked
    //   const user_id = e.target.id
    //   checked_ids = { ...checked_ids, ...{ [user_id]: is_checked } }
    //   const is_any_checked = Object.values(checked_ids).some((value) => value === true)
    //   is_any_checked
    //     ? show_modal_button.classList.add('users__show-modal-button_active')
    //     : show_modal_button.classList.remove('users__show-modal-button_active')
    // }
    // checkboxes_local.forEach((local) => {
    //   local.addEventListener('change', listener_local_checkbox)
    // })
  }
}

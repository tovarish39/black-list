import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    const rows = document.querySelectorAll('.scamers__row_item')
    const start_state = 'active'

    rows.forEach((row) => {
      const status = row.getAttribute('data')
      if (status === 'member') row.classList.remove('scamers__row_item_none')
    })

    const active_button = document.querySelector('#radio-active')
    const inactive_button = document.querySelector('#radio-inactive')
    const buttons = [active_button, inactive_button]

    function handleChange(e) {
      const id = e.target.id
      rows.forEach((row) => row.classList.add('scamers__row_item_none'))

      rows.forEach((row) => {
        const status = row.getAttribute('data')
        if (status === 'member' && id === 'radio-active') {
          row.classList.remove('scamers__row_item_none')
        } else if (status !== 'member' && id === 'radio-inactive') {
          row.classList.remove('scamers__row_item_none')
        }
      })
    }

    buttons.forEach((button) => {
      button.addEventListener('change', handleChange)
    })
  }
}

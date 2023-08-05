import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['spinner']

  connect() {
    this.element.addEventListener('change', async (e) => {
      this.showSpinner() // Показать спиннер
      const new_status_value = e.target.value
      const user_id = e.target.id

      const { updated_status } = await this.processEvent(user_id, new_status_value) // Пример асинхронной обработки (замените на вашу логику)
      e.target.value = updated_status

      this.hideSpinner() // Скрыть спиннер
    })
  }

  async processEvent(user_id, new_status_value) {
    const body = { new_status_value: new_status_value }
    const csrfToken = document.querySelector("[name='csrf-token']").content

    const res = await fetch(`/users/${user_id}`, {
      method: 'PUT',
      body: JSON.stringify(body),
      mode: 'cors', // no-cors, *cors, same-origin
      cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
      credentials: 'same-origin', // include, *same-origin, omit
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
      },
    })

    return res.json()
  }

  showSpinner() {
    this.spinnerTarget.classList.add('visible') // Добавить класс для отображения спиннера
  }

  hideSpinner() {
    this.spinnerTarget.classList.remove('visible') // Убрать класс для скрытия спиннера
  }
}

import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['spinner']

  connect() {
    this.element.addEventListener('change', async (e) => {
      if (e.target.classList.contains('custom-select')) {
        this.showSpinner() // Показать спиннер

        // Здесь выполняется ваша обработка события

        await this.processEvent() // Пример асинхронной обработки (замените на вашу логику)

        this.hideSpinner() // Скрыть спиннер
      }
    })
  }

  async processEvent() {
    // Здесь можете выполнить вашу обработку события, может быть асинхронной
    await new Promise((resolve) => setTimeout(resolve, 2000)) // Пример задержки
  }

  showSpinner() {
    this.spinnerTarget.classList.add('visible') // Добавить класс для отображения спиннера
  }

  hideSpinner() {
    this.spinnerTarget.classList.remove('visible') // Убрать класс для скрытия спиннера
  }
}

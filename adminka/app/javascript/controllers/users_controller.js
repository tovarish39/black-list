import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    // Получаем все радиокнопки в группе
    const radioButtons = this.element.querySelectorAll('input[type="radio"][name="radio"]')

    // Находим выбранную радиокнопку (если есть)
    const checkedRadioButton = this.element.querySelector('input[type="radio"][name="radio"]:checked')

    // Проверяем, если есть выбранная радиокнопка
    if (checkedRadioButton) {
      const selectedValue = checkedRadioButton.value
      console.log(`Стартовое значение: ${selectedValue}`)
    }

    // Добавляем обработчик события для каждой радиокнопки
    radioButtons.forEach((radio) => {
      radio.addEventListener('change', () => {
        // Проверяем, если радиокнопка выбрана
        if (radio.checked) {
          console.log(`Выбрано значение: ${radio.value}`)
        }
      })
    })
  }
}

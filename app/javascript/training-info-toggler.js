document.addEventListener('DOMContentLoaded', () => {
  const checkbox = document.querySelector(
    'input.js-training-info-toggler-checkbox'
  )

  if (checkbox !== null) {
    const dateInput = document.querySelector('input.training-info-date')
    const trainingInfoBlock = document.querySelector('.js-training-info-block')

    if (checkbox.checked === false) {
      trainingInfoBlock.style.display = 'none'
    }

    checkbox.addEventListener('change', () => {
      if (checkbox.checked === true) {
        trainingInfoBlock.style.display = 'block'
      } else {
        dateInput.value = ''
        trainingInfoBlock.style.display = 'none'
      }
    })
  }
})

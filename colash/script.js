function toggleFullScreenImage(index) {
    const fullscreenImage = document.getElementById('fullscreen-image');
    const fullscreenImg = document.getElementById('fullscreen-img');
    const imageTitle = document.getElementById('image-title');
    const imageDescription = document.getElementById('image-description');

    if (index === -1) {
        fullscreenImage.style.display = 'none';
        document.body.style.overflow = 'hidden';
    } else {
        const images = [
            { src: 'ada.jpeg', title: 'Título 1', description: 'Descripción de la imagen 1' },
            { src: 'cascada.jpeg', title: 'Título 2', description: 'Descripción de la imagen 2' },
            { src: 'montanias.jpeg', title: 'Título 3', description: 'Descripción de la imagen 3' },
            { src: 'descarga.jpeg', title: 'Título 4', description: 'Descripción de la imagen 4' }
        ];

        fullscreenImg.src = images[index - 1].src;
        imageTitle.textContent = images[index - 1].title;
        imageDescription.textContent = images[index - 1].description;
        fullscreenImage.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    } 
}

      
let numeroAleatorio = Math.floor(Math.random() * 100) + 1;
console.log("Adivina el número entre 1 y 100");
let intent;
do {
    intent = parseInt(prompt("Ingrese un número:"));
    if (intent < numeroAleatorio) {
        console.log("Más alto");
    } else if (intent > numeroAleatorio) {
        console.log("Más bajo");
    } else {
        console.log("¡Correcto!");
    }
} while (intent !== numeroAleatorio);




// let cantidad = parseInt(prompt("Ingrese la cantidad de números que desea ingresar:"));
// let numeros = [];
// for (let i = 0; i < cantidad; i++) {
//     numeros.push(parseFloat(prompt("Ingrese el número " + (i + 1) + ":")));
// }
// let suma = numeros.reduce((a, b) => a + b, 0);
// let promedio = suma / cantidad;
// let mayor = Math.max(...numeros);
// let menor = Math.min(...numeros);
// alert("Suma: " + suma + "\nPromedio: " + promedio + "\nMayor: " + mayor + "\nMenor: " + menor);

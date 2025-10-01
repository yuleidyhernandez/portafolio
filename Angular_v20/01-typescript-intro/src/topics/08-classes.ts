// import { Person } from './08-classes';


export class Person {
    // public name: string;
    // public address: string;

    constructor(
        public name: string, 
        private address: string ='no address'
    ) {}
        // this.name = '';
        // this.address = '';
    // }
};

// export class Hero extends Person {
//     constructor(public alterEgo: string,
//         public age: number,
//         public realName: string,
//     ) {
//         super(realName, 'new york')
//     }
// }

export class Hero {

    // public person: Person;

    constructor(
        public alterEgo: string,
        public age: number,
        public realName: string,
        public person: Person
    ) {
        // this.person = new Person (realName);

    }
}

const person = new Person('Tony Start', 'new york');
const iroman = new Hero('lola',12,'tony', person);

console.log(iroman);



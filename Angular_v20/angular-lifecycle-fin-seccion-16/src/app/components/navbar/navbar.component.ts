import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';

@Component({
  selector: 'app-navbar',
  imports: [RouterLink, RouterLinkActive],
  templateUrl: './navbar.component.html',
  styles: `

      nav {
        display: flex;
        gap: 1rem;
        justify-content: center;
        align-items: center;
      }w

  `,
})
export class NavbarComponent {}

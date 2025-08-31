## Flutter Reward Screen – Built with a Little AI Help

This is a small Flutter demo I built for a coding task.
The requirements were straightforward:

Show a message: "You've unlocked a $10 reward!"

Add a button: Choose Brand (simulates navigation)

Display 3 mock credit card bills (amount, date, status)

Bonus: add a subtle animation

I also went one step further and built a fun Card Roulette screen, where those mock bills spin in a playful, interactive way. It wasn’t required, but I wanted to show some extra creativity.

## What the app does

When you run it, you’ll see:

A reward message at the top

A “Choose Brand” button in the center

A list of 3 fake credit card bills below

A smooth fade-in animation for the reward text when the screen loads

(Extra) A Card Roulette screen, where those same bills can be browsed with a spin interaction

## How AI actually helped me

I didn’t just dump the problem into an AI and copy-paste the output. Instead, I used it like a sparring partner:

Quick bootstrap
I asked AI: “Give me a Flutter scaffold with a reward text, a button, and a list of cards.”
→ It gave me a solid starting point with Scaffold, Column, and ListView. That shaved off the usual boilerplate time.

UI refinements
I wasn’t happy with the raw layout. I asked: “How can I make these bills look modern and consistent?”
→ AI suggested wrapping each in a Card with padding and rounded corners. I tweaked spacing, typography, and colors myself.

Animation tip
For the subtle micro-interaction, I asked: “What’s the simplest fade-in animation in Flutter?”
→ It suggested AnimatedOpacity. I used it so the reward message gently fades in.

Debugging shortcut
My button alignment was stubbornly off. Instead of wasting time experimenting, I asked AI.
→ It reminded me to wrap the button in Center. Problem solved instantly.

Card Roulette idea
I brainstormed how to make the bills feel more engaging. AI suggested exploring PageView and animations.
→ That pushed me to build the extra Card Roulette screen, where the cards rotate in and out like a carousel.

## Where AI tripped up

It wasn’t flawless:

It first suggested FlatButton, which is deprecated. I replaced it with ElevatedButton.

Its animation suggestions were sometimes overcomplicated. I had to simplify them to keep the UI smooth.

For the Card Roulette, AI’s first code didn’t fully work—I had to debug the math and tweak animation controllers manually.

## My takeaway

AI didn’t build this app for me.
But it:

Helped me start faster (no boilerplate drag)

Acted like a debugging buddy

At the same time, I had to do the polishing, fix outdated snippets, and make judgment calls on design.
So I’d call it more of a creative partner than a code generator.


This project was built by me, with AI acting as a helpful (and sometimes clumsy) coding partner.
The extra Card Roulette screen is my way of showing how I take ideas further when I have some room to experiment.
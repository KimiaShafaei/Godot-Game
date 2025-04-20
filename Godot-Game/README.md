# Godot-Game Documentation

## Project Overview

This project is a 2D game developed using Godot Engine, featuring an enemy character with various states including walking, running, shooting, dying, and idle. The enemy character's behavior is managed through a state management system that allows for smooth transitions between different actions based on game events.

## Project Structure

- **Assets**
  - **Sprites**
    - **Characters**
      - **enemy**: Contains sprite assets for the enemy character.
      - **blood**: Contains sprite assets for blood effects.
  - **Musics**: Contains audio files for game sound effects and background music.

- **Scenes**
  - **Prefabs**
    - **Characters**
      - **enemy.tscn**: The main scene file for the enemy character, serving as the parent node for the enemy and containing references to the state management system.
      - **States**
        - **walk.gd**: Script defining the behavior for the walking state of the enemy, handling movement logic and animations.
        - **run.gd**: Script defining the behavior for the running state of the enemy, managing faster movement and corresponding animations.
        - **shoot.gd**: Script defining the behavior for the shooting state of the enemy, handling shooting mechanics and animations.
        - **die.gd**: Script defining the behavior for the dying state of the enemy, managing the death animation and cleanup.
        - **idle.gd**: Script defining the behavior for the idle state of the enemy, managing idle animations and logic.
  - **Main.tscn**: The main scene of the game.

- **Scripts**
  - **enemy.gd**: Manages the enemy's overall behavior and state transitions, referencing the state scripts and handling switching based on conditions (e.g., player proximity, health).
  - **state_manager.gd**: Manages state transitions for the enemy, tracking the current state and handling switching based on events or conditions.

## Implementation Notes

1. **State Management**: A base state class can be created to provide common functionality for all state scripts. This will help in maintaining a clean and organized code structure.
2. **State Initialization**: In `enemy.gd`, instantiate the state manager and set the initial state (e.g., idle).
3. **State Logic**: Each state script (e.g., `walk.gd`) should implement logic for entering, updating, and exiting the state. This includes handling animations and any specific behaviors associated with that state.
4. **State Transitions**: Use signals or method calls to transition between states based on game events, such as detecting the player for running or shooting.

## Future Improvements

- Expand the enemy's behavior with additional states or refine existing ones based on gameplay testing.
- Implement more complex AI behaviors for the enemy character.
- Add sound effects and music to enhance the gaming experience.

This README serves as a guide for understanding the structure and functionality of the project. Further documentation can be added as the project evolves.
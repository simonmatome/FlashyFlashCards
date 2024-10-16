# FlashyFlashCards
With this app, I wanted to make a free flashcard app for myself that has a basic implementation of the [spaced repetition algorithm](https://en.wikipedia.org/wiki/Spaced_repetition). 
I wanted the app to have basic LaTeX to display math symbols to fascilitate creating theorem and equation flashcards. The app employs the MVVM architecture albeit a very crude and elementary one. 
It has 4 main tabs providing users with the necessary grouped functionality being:
- Flashy Flash
- Library
- Statistics
- Settings

I will go over each tab explaining the functionality it provides.

<br>

## Library

### Accessing different subjects, adding/deleting subjects
<img align="left" src="https://github.com/user-attachments/assets/5a3bf13c-2935-4d72-9f8a-3ba5882a1569" width="25%"/> 

The app has a library which stores all the subjects and topics.
As can be seen from the screenshot, the app employs a "file" user-interface on the different subjects. To access multiple topics per-subject, one would have to swipe across the topics.
The **Library** tab has an:
- **add subject** button which allows one to add subjects to the database
- **delete subject** button which gives the user an option to delete a subject and all its data if they so wish.
To access the different subjects within the tab, one has to scroll and there is a smooth scroll animation for aesthetic appeal.


<BR CLEAR="left">

### Editing existing subjects and topics

The subject has an interface that surfaces after the user clicks on a subject name inside the **Library** tab. The interface has various functions summarised in the table. The **Edit topic**
interface only surfaces after the user clicks on the topic-name in the **Edit Subject** interface. The functions in the two interfaces are explained below:

| Edit subject | Edit topic|
|:---:|:---:|
| <img align="center" width=30%  src="https://github.com/user-attachments/assets/467bdbb3-7bc8-438c-a177-a2be3e2feb3e"/> | <img align="center" width=30% src="https://github.com/user-attachments/assets/58abfc24-d388-4120-a5b8-9c45d3fc80ec"/> |
| Functions: <ul align="left"><li>Edits the subject name</li><li>Edits the subject marker color</li><li>Changes the file background color</li><li>Edits topic name and properties</li><li>Add a new topic or swipe left on name to delete topic</li></ul> |Functions: <ul align="left"><li>Edits the topic name</li><li>Edits the times at each stage for a card to reappear after rating</li></ul> |

<br>

## Flashy Flash
<img align="right" width="20%" src="https://github.com/user-attachments/assets/09e176ec-d43f-46e1-bd28-5bc9c7386c00"/>


This tab has the interface for the algorithm I have implemented. Inside the tab, the user engages with the cards-due at the time and rates them according to difficulty. There are five difficulty levels which are all color coded:
- $\color{red}\text{Very Hard}$
- $\color{orange}\text{Hard}$
- $\color{yellow}\text{Moderate}$
- $\color{limegreen}\text{Easy}$
- $\color{green}\text{Very Easy}$

Once the user is done rating all the cards-due, the topics and subjects are cleared from the **Flashy Flash** tab and the user waits until the time has elapsed for a card with the shortest waiting time according to its difficulty.
When a card is ready to get reviewed, a notification is sent to the user and the card re-appears in the Flashy Flash tab with the tag showing the number of card difficulties due at the time.

<BR CLEAR="left">

<br>

| Question | Answer and Rating Menu |
| :---:|:---:|
| <img width="30%" src="https://github.com/user-attachments/assets/b04fd116-8c11-4f70-8299-5c8b9ecb953b"> | <img width="30%" src="https://github.com/user-attachments/assets/3e786d41-2a89-4ba0-b14c-9e824a4bfc74">|

<br>

## Statistics

<img align="left" width="20%" src="https://github.com/user-attachments/assets/74c3ac7d-73ed-48eb-b77f-fa12c06c0fe4">

The statistics tab was meant to show more statics relating to the cards themselves, so far the only statistics I have managed to implement are the ones showing the number of cards currently under review and the total number of cards in each difficulty per subject.
More data can be stored to display more statistics as the app is refined.

<BR CLEAR="left">

<br>

## Settings

<img align="right" width="20%" src="https://github.com/user-attachments/assets/2467c87c-1bd2-4dbe-a2e6-e174fa23ba7c">

The settings tab is the most minimal of all tabs with a few buttons to:
- Choose the background color of the whole app and in extension, theme.
- Clear all subjects from the Flash Flash tab which would also delete the progress of the user in learning the cards.
- Delete all subjects from the library, which would delete the user's progress in learning cards and delete all cards stored in the device up-to-date.

<br clear="right">

## Packages

I used only one package in my project which has its own dependencies as well being [LaTeXSwiftUI](https://github.com/colinc86/LaTeXSwiftUI.git).

## Acknowledgements

I would like to thank the following creators for improving my level of knowledge for software development with the content they provide online:

- [Paul Hudson](https://youtube.com/@twostraws) 
- [Sean Allen](https://youtube.com/@seanallen)
- [Karin Prater](https://youtube.com/@swiftyplace)
- [Swiftful Thinking](https://youtube.com/@swiftfulthinking)
- [Apple developer website](https://developer.apple.com/tutorials/app-dev-training/persisting-data)

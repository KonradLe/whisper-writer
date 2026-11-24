# WhisperWriter: fork z poprawką dla Windows

To fork programu [WhisperWriter](https://github.com/savbell/whisper-writer) (autorka: savbell,
licencja GPL-3.0). WhisperWriter to mały program w Pythonie: po naciśnięciu skrótu nagrywa
mowę, zamienia ją na tekst lokalnym modelem Whisper
([faster-whisper](https://github.com/SYSTRAN/faster-whisper)) i wpisuje go w aktywne okno.
Działa bez internetu i bez karty graficznej.

> English: [README.md](README.md)

## Co zmieniliśmy

Zmiany: KonradLe, 2026, na licencji GPL-3.0 jak oryginał.

1. **Poprawka: program na Windowsie nie startuje i nie pokazuje błędu** (15.07.2026,
   `src/main.py`). Model faster-whisper (CTranslate2) tworzony po załadowaniu PyQt5
   wywraca proces (segfault, kod 139), a `pythonw` nic nie wypisuje. To konflikt bibliotek
   natywnych Qt i CTranslate2; ustawienie `KMP_DUPLICATE_LIB_OK` nie pomaga. Teraz
   `main.py` wczytuje lokalny model na samym początku, przed importem PyQt5, i potem z niego
   korzysta. Przy transkrypcji przez API nic się nie zmienia.
2. **Python 3.13** (`requirements-py313.txt`). Oryginalny `requirements.txt` przypina wersje
   z 2024 r. (m.in. numpy 1.24, numba, llvmlite), których nie da się zbudować na Pythonie
   3.13. Ten plik to dokładny zestaw paczek, który działa u nas: Windows 10, Python 3.13.3,
   sam procesor.
3. **Pliki do uruchamiania na Windowsie.** `WhisperWriter.bat` uruchamia program bez okna
   konsoli, a `WhisperWriter-debug.bat` zostawia konsolę z komunikatami, więc widać błędy
   i pobieranie modelu. Oba najpierw przechodzą do folderu programu, bo WhisperWriter szuka
   ustawień po ścieżkach względnych.

## Instalacja na Windowsie (Python 3.13)

```bat
git clone https://github.com/KonradLe/whisper-writer
cd whisper-writer
py -3.13 -m venv .venv
.venv\Scripts\python -m pip install -r requirements-py313.txt
WhisperWriter-debug.bat
```

Przy pierwszym uruchomieniu otworzy się okno ustawień. Do pracy bez internetu zostaw model
lokalny i ustaw: model (`base` jest szybszy, `small` lepiej rozumie polski), `device: cpu`,
`compute_type: int8` i język `pl`. Po zapisaniu program sam uruchomi się ponownie. Kliknij
**Start**, a program schowa się do zasobnika. Naciśnij skrót (domyślnie `ctrl+shift+space`),
mów, a tekst wpisze się w aktywne okno. U nas działa tryb `press_to_toggle`: pierwsze
naciśnięcie zaczyna nagrywanie, drugie je kończy. Na co dzień uruchamiaj program plikiem
`WhisperWriter.bat`.

## Wskazówki z naszego komputera

- **Przypnij mikrofon po nazwie.** Przy pustym `sound_device` WhisperWriter nagrywa
  z domyślnego wejścia Windows. Gdy podłączyliśmy przejściówkę HDMI, Windows bez pytania
  zrobił z niej domyślny mikrofon. Program nagrywał ciszę, a Whisper zamieniał ją na
  zapętlone, zmyślone zdania. Wpisz w `sound_device` fragment nazwy mikrofonu (w oknie
  ustawień albo w `src/config.yaml`). Biblioteka sounddevice szuka go jako fragmentu
  nazwy, więc wpisz tyle, żeby pasował tylko do wejścia: sama nazwa producenta pasowała
  u nas też do wyjść i program zgłaszał błąd. Listę urządzeń pokaże
  `.venv\Scripts\python -m sounddevice`.
- **Wybierz wariant urządzenia z listy MME.** WhisperWriter nagrywa w 16 kHz, a wariant
  WASAPI tego samego mikrofonu potrafi tej częstotliwości nie przyjąć
  (`Invalid sample rate -9997`).
- **Cztery procesy Pythona przy jednym uruchomieniu to norma na Windowsie:** `run.py`
  uruchamia `main.py` jako osobny proces, a każdy Python ze środowiska venv to mały program
  startowy i właściwy interpreter.

Całość, czyli dyktowanie na komputerze i zamianę nagrań na tekst na serwerze, opisaliśmy
w artykule [Jak pisać głosem na komputerze](https://zautomatyzowani.ai/faq/pisanie-glosem-na-komputerze/).

Pełny opis programu, wszystkie opcje i instrukcja dla innych systemów są w
[README.md](README.md) (po angielsku).

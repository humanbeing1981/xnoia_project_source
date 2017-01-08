\*SuperCollider, Python and Java/Processing code for the xnoia project (MA Thesis at EKPA)
by A.S.S.

\*\*What it is about

This project is about the Greek synthetic word "-noia" that derive from (νους)
meaning mind and how this correlates to the modern life of man seen through an
opticoacoustic performance.

For the implementation of this project I use the Neurosky Mindwave device to trigger
sound and visuals.

Below there is a description of each file in this repository and a short guide on how to install and run the necessary components.

\*\*\*mind<sub>alex.py</sub>

On this Python file we have the code to enable us to receive information from the Neurosky Mindwave device and send OSC messages to Supercollider.
In order for this to work one will need the NeuroPy module for Python availiable from <https://github.com/lihas/NeuroPy>.
This library is written in Python and was created to connect, interact and receive data from the headset device.
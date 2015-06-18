# Getting Started

In order to get started with the exercise, follow the instructions below
according to your platform.

We are going to use `ipython notebook`. More info about the installation
procedure can be found [here](http://ipython.org/install.html)

## Linux

Download and install `Anaconda`. In the terminal, run:

    $ wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda-2.2.0-Linux-x86_64.sh
    $ chmod +x Anaconda-2.2.0-Linux-x86_64.sh
    $ ./Anaconda-2.2.0-Linux-x86_64.sh

And follow the instructions.

Once Anaconda is installed, update IPython to the current version and install
extra dependencies:

    $ conda update conda
    $ conda update ipython ipython-notebook ipython-qtconsole
    $ conda install pandas ipython scikit-learn
    $ conda install -c https://conda.binstar.org/bokeh ggplot

Run ipython notebook with:

    $ cd /path/to/this/git/repository
    $ ipython notebook

## MacOSX and other systems

For MacOSX and Windows the steps are roughly the same.

To install `Anaconda`, Check the instructions [here](http://continuum.io/downloads)

In your favorite shell, run:

    $ conda update conda
    $ conda update ipython ipython-notebook ipython-qtconsole

Once Anaconda is installed, update IPython to the current version and install
extra dependencies:

    $ conda update conda
    $ conda update ipython ipython-notebook ipython-qtconsole
    $ conda install pandas ipython scikit-learn
    $ conda install -c https://conda.binstar.org/bokeh ggplot

Run ipython notebook with:

    $ cd /path/to/this/git/repository
    $ ipython notebook

# Python customizations

## Install & configure conda  

See [instructions](https://conda.io/docs/user-guide/install/index.html#)  
TLDR

* Download [linux installer](https://docs.conda.io/en/latest/miniconda.html)  
* install with `bash minicon.....`

Install some essentials

```bash
conda install -c conda-forge -y
# https://pypi.python.org/pypi/nbstripout for .ipynb files  
nbstripout  

# Jupyter or JupyterLab http://jupyterlab.readthedocs.io/en/stable/getting_started/installation.html  
jupyter

# Ipython helpers
ipykernel
nb_conda
nb_conda_kernels
cookiecutter

```

Configure [jupyterthemes](https://github.com/dunovank/jupyter-themes)

```bash
pip install --upgrade jupyterthemes
jt -t onedork -N -fs 95 -altp -tfs 11 -nfs 115 -cellw 95% -T -dfs 8
```

## Use [environments](https://conda.io/docs/user-guide/tasks/manage-environments.html)  
There are some important idiosyncracies to consider when using environments and jupyter notebook/lab.  

* The jupyter libraries should be installed in your `base env`. They do not need to be included in each custom `env`.  
* You should launch jupyter notebook/lab from a sensible root directory not from the root of the project, so that jupyter notebook/lab has access to all projects.
* Environment switching happens by specifying a kernel in the notebook, so always launch jupyter notebook/lab from the `base environment`.
* See also: The [mystery of environemnts, Kernels, and Jupyter notebook](https://github.com/Anaconda-Platform/nb_conda_kernels)

#### Creating a new environment  

Environments keep track of your project requirements and sandbox your code so that others can reproduce your analyses easily. To create a new environemnt:

1. Open a local terminal or a new terminal in Jupyter Lab.  
2. Execute `conda create -n <my_environment_name>`. [Help here](https://conda.io/docs/commands/conda-create.html)  
3. Activate the new evironment with `source activate <my_environment_name>`
4. Install required packages using pip, conda or other python package installation method.
5. #TODO To see the new evironment in Jupyterlab either re-build the container or select 'shutdown all kernels' from the Kernel menu and refresh the page. Your new environment should appear on the launcher page and in the kernel selection menus.
6. Create an environment file as described below.  

#### Creating an environment file  

Creating an environment file allows one to install packages automatically.  
From a local terminal or from the Jupyter lab terminal, run  

```bash  
# Substitute your environment's name for <myenvironment>
conda activate <myenvironment>

# Substitute your project's directory for <myproject>
conda env export > <myproject>/environment.yml  
```

Your environment configuration can be shared with your source code to rebuild your exact environment and reproduce your analyses elsewhere. :-)

### Rebuilding an environment from a file  

Note that conda has some bugs when re-creating environments. A workaround is to manually remove version numbers and problematic dependencies in the auto-created `environment.yml`.

```bash
name= 
conda env create --file environment.yml -n $name
# This should not be necessary
# install environment kernel in jupyter
source activate $name
conda install -c conda-forge ipykernel
ipython kernel install --name=$name
```

## Pro Tips

* `%lsmagic` for available magic commands
* About Python [debugging](https://stackoverflow.com/questions/32409629/what-is-the-right-way-to-debug-in-ipython-notebook) in a jupyter notebook
  * `%pdb` for a cell 
  * `import pdb; pdb.set_trace()` for breakpoint
  * For the entire notebook

    ```python
    # Set debugging preferences
    import pdb
    %pdb off
    %xmode plain
    ```

* Set [theme](https://github.com/dunovank/jupyter-themes)

    ```python
    # Set theme
    from jupyterthemes import jtplot
    !jt -t onedork -fs 95 -altp -tfs 11 -nfs 115 -cellw 98% -T
    jtplot.style()
    ```
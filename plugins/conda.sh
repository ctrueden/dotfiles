# Enable conda if installed.
if [ -d "$HOME/miniconda3" ]
then
  . "$HOME/miniconda3/etc/profile.d/conda.sh"
elif [ -d /usr/local/miniconda3 ]
then
  . /usr/local/miniconda3/etc/profile.d/conda.sh
fi

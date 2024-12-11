@echo off

set gpu=%1
set bz=%2

:: Current directory
set CURRENT_DIR=%cd%
:: Script directory
set SCRIPT_DIR=%~dp0
:: Change to script directory
cd /d %SCRIPT_DIR%

:: Find the Python environment path with the word "retrosub"
for /f "tokens=2" %%a in ('conda env list ^| findstr /i "retrosub"') do set python_dir=%%a


python ..\MolecularTransformer\translate.py ^
    -model ..\models\uspto_full_retrosub.pt ^
    -src test_input_seq2seq.txt ^
    -output predict_output.txt ^
    -batch_size %bz% -replace_unk -max_length 200 -fast -n_best 10 -beam_size 10 -gpu %gpu%

:: Return to the original directory
cd /d %CURRENT_DIR%

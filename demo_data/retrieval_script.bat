@echo off

:: Current directory
set CURRENT_DIR=%cd%

:: Script directory
for %%F in ("%~dp0") do set SCRIPT_DIR=%%F

:: Change to script directory
cd /d %SCRIPT_DIR%

:: Retrieve top 20 candidates
set top=20

set retrieval_model_dir=..\ckpts\uspto_full\dual_encoder\epoch116_batch349999_acc0.79
set data_dir=..\data\uspto_full

:: Find the Python environment path with the word "retrieval"
for /f "tokens=2" %%a in ('conda env list ^| findstr /i "retrieval"') do set python_dir=%%a

:: Print the found environment path
echo Found environment path: %python_dir%

:: Run the retrieval script
%python_dir%\python -u ..\RetrievalModel\search_index.py ^
        --input_file test_input_dual_encoder.txt ^
        --output_file test_input_dual_encoder.top%top%.txt ^
        --ckpt_path %retrieval_model_dir%\query_encoder ^
        --args_path %retrieval_model_dir%\args ^
        --vocab_path %data_dir%\retrieval\src.vocab ^
        --index_file %data_dir%\candidates.txt ^
        --index_path %retrieval_model_dir%\mips_index ^
        --topk %top% ^
        --allow_hit ^
        --batch_size 1024

:: Change back to current directory
cd /d %CURRENT_DIR%

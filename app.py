import os

from flask import Flask, jsonify
from flask import Flask, render_template, request, redirect, url_for, session, Response
from werkzeug.utils import secure_filename
from solcx import compile_standard, install_solc
import subprocess
import json
import tempfile
import logging

import traceback

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'E:\BlockChainProject\\rtsscdemo\Subjects'


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/upload_contract', methods=['GET', 'POST'])
def upload_contract():
    if request.method == 'GET':
        return render_template('1funIdentify.html')
    elif request.method == 'POST':
        contract_file = request.files['contract_file']
        contract_file.save(os.path.join(app.config['UPLOAD_FOLDER'], secure_filename(contract_file.filename)))
        print(contract_file.filename)
        with open(os.path.join(app.config['UPLOAD_FOLDER'], contract_file.filename), 'rb') as file:
            contract_source_code = file.read()
            print(contract_source_code)
            # 通过sloc编译智能合约
            # install_solc("0.6.0")
            # compiled_sol = compile_standard(
            #     {
            #         "language": "Solidity",
            #         "sources": {contract_file.filename: {"content": contract_source_code.decode('utf-8')}},
            #         "settings": {
            #             "outputSelection": {
            #                 "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            #             }
            #         },
            #     },
            # )
            # print(compiled_sol)
            #abi = compiled_sol['contracts'][contract_file.filename][contract_file.filename]['abi']
            #print(abi)
            result = subprocess.run(['slither', contract_file.filename, '--json', 'slither.json'],
                                    capture_output=True, text=True)
            print(result)
            if contract_file and contract_file.filename.endswith('.sol'):
                # 创建临时文件保存上传的合约
                temp_dir = tempfile.mkdtemp()
                contract_path = os.path.join(temp_dir, contract_file.filename)
                contract_file.save(contract_path)
                logging.info(f"File saved to {contract_path}")

                try:
                    # 调用Slither进行静态分析
                    result = subprocess.run(
                        ['slither', contract_path, '--json slither.json'],
                        capture_output=True,
                        text=True,
                        check=True
                    )
                    # 解析分析结果
                    analysis_results = json.loads(result.stdout)
                    print(analysis_results)

                    # 清理临时文件
                    os.remove(contract_path)
                    os.rmdir(temp_dir)

                    #return jsonify(analysis_results)

                except subprocess.CalledProcessError as e:
                    # 如果Slither执行失败，记录错误信息
                    logging.error(f"Slither analysis failed: {e.stderr}")
                    return jsonify(error="Slither analysis failed", details=e.stderr), 500
                except json.JSONDecodeError as e:
                    # 如果结果JSON解析失败，记录错误信息
                    logging.error(f"Failed to parse Slither output: {e}")
                    return jsonify(error="Failed to parse Slither output", details=str(e)), 500
                finally:
                    # 确保即使出现错误也会清理临时文件
                    if os.path.exists(contract_path):
                        os.remove(contract_path)
                    if os.path.exists(temp_dir):
                        os.rmdir(temp_dir)
            else:
                print('error')
                #return jsonify(error="Invalid file type"), 400

        return render_template('1funIdentify.html')


if __name__ == '__main__':
    app.run(debug=True)

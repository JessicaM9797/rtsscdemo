# 调用工具生成智能合约测试用例
import solc
import json

def compile_contract(file_path):
    solc.install_solc("latest")  # 安装最新的 Solidity 编译器

    with open(file_path, 'r') as file:
        contract_source_code = file.read()

    # 编译合约
    compiled_contract = solc.compile_source(contract_source_code)

    # 获取编译后的合约 ABI
    contract_abi = compiled_contract['<ContractName>']['abi']  # 将 <ContractName> 替换为你的合约名称

    # 将 ABI 数据以 JSON 格式保存到文件
    with open('contract_abi.json', 'w') as abi_file:
        json.dump(contract_abi, abi_file, indent=4)

    return contract_abi

# 使用示例：
contract_file_path = 'E:\P-project\mt4scdemo\Subjects\Auction.sol'  # 替换为你的合约文件路径
abi_data = compile_contract(contract_file_path)
print("ABI 数据已生成并保存到 contract_abi.json 文件中。")

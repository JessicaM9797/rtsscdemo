from slither import Slither
import os.path

def analyze_contract(file_path):
    slither = Slither(file_path)

    # 获取所有合约
    contracts = slither.contracts

    # 用于存储分析结果的列表
    analysis_result = []

    # 遍历每个合约并分析
    for contract in contracts:
        # 运行分析器
        contract.analyze()

        # 获取合约中的问题
        issues = contract.issues

        # 将分析结果存储在字典列表中
        for issue in issues:
            analysis_result.append({
                'contract_name': contract.name,
                'title': issue.check.name,
                'description': issue.description,
                'severity': issue.severity.name,
                # 可根据需要获取其他信息
            })

    return analysis_result

# 上传合约文件路径.
contract_file_path = 'E:\BlockChainProject\RTSSC_demo\Subjects\Auction.sol'

# 分析合约
result = analyze_contract(contract_file_path)
print(result)

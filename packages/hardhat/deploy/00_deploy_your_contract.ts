import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

/**
 * Deploys a contract named "BusinessListingContract" using the deployer account and
 * constructor arguments set to the deployer address
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployYourContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const usdtAddress = "0xdAC17F958D2ee523a2206206994597C13D831ec7";

  // Deploy BusinessPoolToken
  const businessPoolTokenDeployment = await deploy("BusinessPoolToken", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  const poolTokenAddress = businessPoolTokenDeployment.address;

  // Deploy BusinessPooling
  await deploy("BusinessPooling", {
    from: deployer,
    args: [usdtAddress, poolTokenAddress], // BusinessPooling initialization
    log: true,
    autoMine: true,
  });
};

export default deployYourContract;

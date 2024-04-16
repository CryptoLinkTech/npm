declare namespace ChainsConfig {
  interface ChainConfig {
    message: string;
    featureGateway?: string;
    usdc?: string;
    weth?: string;
    stable?: string;
    feeToken?: string;
  }

  interface ChainsConfig {
    [key: string]: ChainConfig;
  }
}

declare const chainsConfig: ChainsConfig.ChainsConfig;
export = chainsConfig;
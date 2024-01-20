declare module '@cryptolink/contracts' {
  interface ChainConfig {
    message: string;
    weth?: string;
    stable?: string;
    feeToken?: string;
  }

  interface ChainsConfig {
    [key: string]: ChainConfig;
  }

  const chainsConfig: ChainsConfig;
  export = chainsConfig;
}

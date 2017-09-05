%.evmc: %.evm; sed 's/#.*//' $< | tr -d ' \n' >$@
evmdis: cabal.evmc; evmdis < $<

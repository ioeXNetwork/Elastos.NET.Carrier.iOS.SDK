# IOEX Carrier iOS Framework

## Summary

IOEX leveraged Elastos functions to create its owned features and also business cases.

IOEX Carrier iOS Framework is swift API wrapper (also produced in Object-C APIs for IOEX BravoMesh Carrier Module SDK, where Carrier is a decentralized peer to peer communication framework.

## Build from source

### 1.Build Carrier NDK

You need to build carrier iOS ndk distributions from the Carrier native repository with following github address.

```
https://github.com/ioeXNetwork/ioeX.BravoMesh.CarrierModule
```

Finished building iOS NDKs for Carrier, you would have native output libraries 'lipo'ed with serveral CPU architectures supported. Currently, only x86-64 and arm64 CPU architectures are supported.

The output static libraries would be listed under "_dist/lipo" directory in Carrier Native source.

### 2.Import Carrier NDK

The directory "NativeDistributions" where to import native libraries and headers has the following directory structure:

```
NativeDistributions
   |--include
       |--IOEX_carrier.h
       |--IOEX_session.h
       |--CCarrier.swift
       |--CSession.swift
   |--libs
       |--libelacarrier.a
       |--libelacommon.a	
       |--libelasession.a	
       |--libflatcc.a	
       |--libflatccrt.a	
       |--libpj.a		
       |--libpjlib-util.a	
       |--libpjmedia.a	
       |--libpjnath.a	
       |--libsodium.a	
       |--libtoxcore.a
```
The headers under directory "include" are public header files from Carrier native. 

### 3. Build Carrier SDK

After importing dependencies from Carrier native, you need Xcode to open this project and build Carrier iOS SDK.

### 4. Output

You can use Xcode to produce IOEXCarrier.framework.

## Tests

To complete.

## Build Docs

To complete.

## Thanks

Sinserely thanks to all teams and projects that we relying on directly or indirectly.

## Contributing

We welcome contributions to the IOEX Carrier iOS Project (or Native Project) in many forms.

## License

IOEX Carrier iOS Project source code files are made available under the MIT License, located in the LICENSE file. 

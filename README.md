#ioeX Network iOS Framework

## Summary

#ioeX leveraged Elastos functions to create its owned features and also business cases.

ioeX Network iOS Framework is swift API wrapper (also produced in Object-C APIs for ioeX.BravoMesh.Network, where Network is a decentralized peer to peer communication framework.

## Build from source

### 1.Build Network NDK

You need to build iOS ndk distributions from the Network native repository with following github address.

```
https://github.com/ioeXNetwork/ioeX.BravoMesh.Network
```

Finished building iOS NDKs for Network, you would have native output libraries 'lipo'ed with serveral CPU architectures supported. Currently, only x86-64 and arm64 CPU architectures are supported.

The output static libraries would be listed under "_dist/lipo" directory in Network Native source.

### 2.Import Network NDK

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
The headers under directory "include" are public header files from Network native. 

### 3. Build Network SDK

After importing dependencies from Network native, you need Xcode to open this project and build iOS SDK.

### 4. Output

You can use Xcode to produce framework.

## Tests

To complete.

## Build Docs

To complete.

## Thanks

Sinserely thanks to all teams and projects that we relying on directly or indirectly.

## Contributing

We welcome contributions to the IOEX Network iOS Project (or Native Project) in many forms.

## License

IOEX Network iOS Project source code files are made available under the GPLv3 License, located in the LICENSE file.
#ifndef MHY_DISTORTION_NEW_INCLUDED
#define MHY_DISTORTION_NEW_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

half _DistortionTexRG_Uspeed;
half _DistortionTexRG_Vspeed;
half _DistortionRScaler;
half _DistortionGScaler;
half _DistortionMaskChannelToggle;
half _DistortionOpacity;
half4 _MeshParticleColorArray;
half _Alpha;
half _MotionVectorsAlphaCutoff;
half _MHYZBias;
half _PolygonOffsetFactor;
half _PolygonOffsetUnit;
half4 _DistortionTexRG_ST;
half4 _DistortionMask_ST;
half4 _texcoord_ST;

TEXTURE2D(_DistortionTexRG); SAMPLER(sampler_DistortionTexRG);
TEXTURE2D(_DistortionMask); SAMPLER(sampler_DistortionMask);
TEXTURE2D(_texcoord); SAMPLER(sampler_texcoord);

#endif
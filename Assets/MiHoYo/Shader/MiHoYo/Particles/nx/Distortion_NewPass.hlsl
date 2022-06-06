#ifndef MHY_DISTORTION_NEW_PASS_INCLUDE
#define MHY_DISTORTION_NEW_PASS_INCLUDE

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
// #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
// #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/ImageBasedLighting.hlsl"
// #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

struct Attributes
{
    half4 positionOS   : POSITION;
    half4 color        : COLOR;
    half2 uv           : TEXCOORD00;
};

struct Varyings
{
    half4 positionCS   : SV_POSITION;
    half4 color        : COLOR;
    half4 distortXYMaskZW : TEXCOORD00;
};

Varyings DistortionNewMainVertex(Attributes input)
{
    Varyings output = (Varyings)0;
    float3 positionOS = input.positionOS;
    VertexPositionInputs vertexInput = GetVertexPositionInputs(positionOS.xyz);
    output.positionCS = vertexInput.positionCS;
    output.positionCS.z += _MHYZBias * vertexInput.positionCS.w;
    return output;
}

half4 DistortionNewMainFragment(Varyings input) : SV_Target
{
    half4 finalCol;
    finalCol.rgb = input.color.rgb;
    finalCol.a = 0;
    return finalCol;
}

Varyings DistortionNewVertex(Attributes input)
{
    Varyings output = (Varyings)0;
    float3 positionOS = input.positionOS;
    VertexPositionInputs vertexInput = GetVertexPositionInputs(positionOS.xyz);
    output.positionCS = vertexInput.positionCS;
    output.positionCS.z += _MHYZBias * vertexInput.positionCS.w;
    output.color = input.color;

    half2 distortUV = TRANSFORM_TEX(input.uv.xy, _DistortionTexRG);
    distortUV += _Time.y * half2(_DistortionTexRG_Uspeed, _DistortionTexRG_Vspeed);
    half2 maskUV = TRANSFORM_TEX(input.uv.xy, _DistortionMask);
    output.distortXYMaskZW.xy = distortUV;
    output.distortXYMaskZW.zw = maskUV;
    return output;
}

half4 DistortionNewFragment(Varyings input) : SV_Target
{
    half4 distortTexMap = SAMPLE_TEXTURE2D(_DistortionTexRG, sampler_DistortionTexRG, input.distortXYMaskZW.xy);
    half2 distortColor = half2(0.5 - distortTexMap.x, distortTexMap.y - 0.5) * half2(_DistortionRScaler, _DistortionGScaler);
    half4 distortMaskMap = SAMPLE_TEXTURE2D(_DistortionMask, sampler_DistortionMask, input.distortXYMaskZW.zw);

    half maskValue = _DistortionMaskChannelToggle == 3.0 ? distortMaskMap.a : 0;
    maskValue = _DistortionMaskChannelToggle == 2.0 ? distortMaskMap.b : maskValue;
    maskValue = _DistortionMaskChannelToggle == 1.0 ? distortMaskMap.g : maskValue;
    maskValue = _DistortionMaskChannelToggle == 0.0 ? distortMaskMap.r : maskValue;

    half4 finalCol;
    finalCol.rg = saturate(distortColor.xy + 0.5);
    finalCol.b = 0;
    finalCol.a = maskValue * input.color.a * _DistortionOpacity * _Alpha;
    return finalCol;
}

#endif
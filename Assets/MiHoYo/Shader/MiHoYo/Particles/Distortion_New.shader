Shader "miHoYo/Particles/Distortion_New" {
    Properties {
        _DistortionTexRG ("DistortionTex(RG)", 2D) = "white" { }
        _DistortionTexRG_Uspeed ("DistortionTex(RG)_Uspeed", Float) = 0
        _DistortionTexRG_Vspeed ("DistortionTex(RG)_Vspeed", Float) = 0
        _DistortionRScaler ("DistortionRScaler", Float) = 2
        _DistortionGScaler ("DistortionGScaler", Float) = 2
        _DistortionMask ("DistortionMask", 2D) = "white" { }
        [Enum(R, 0, G, 1, B, 2, A, 3)] _DistortionMaskChannelToggle ("DistortionMaskChannelToggle", Float) = 2
        _DistortionOpacity ("DistortionOpacity", Float) = 0.5
        _MeshParticleColorArray ("MeshParticleColorArray", Vector) = (1,1,1,1)
        _Alpha ("Alpha", Float) = 1
        _texcoord ("", 2D) = "white" { }
        [Header(Motion Vectors)] _MotionVectorsAlphaCutoff ("Motion Vectors Alpha Cutoff", Range(0, 1)) = 0.1
        [Header(Cull Mode)] [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Float) = 2
        _MHYZBias ("Z Bias", Float) = 0
        _PolygonOffsetFactor ("Polygon Offset Factor", Float) = 0
        _PolygonOffsetUnit ("Polygon Offset Unit", Float) = 0
        _SrcBlendMode ("Src Blend Mode", Float) = 1
        _DstBlendMode ("Dst Blend Mode", Float) = 0
        _BlendOP ("BlendOp Mode", Float) = 0
        [Header(Depth Mode)] [Enum(Off, 0, On, 1)] _Zwrite ("ZWrite Mode", Float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _Ztest ("ZTest Mode", Float) = 4
        [Header(Fog Mode)] [Toggle(EFFECTED_BY_FOG)] _EffectedByFog ("Effected by fog", Float) = 0
    }
        
    SubShader
    {
        LOD 200
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
            "IgnoreProjector" = "True"
        }

        pass
        {
            Name "MAIN"
            Tags
            {
                // to fix
                "LightMode" = "SRPDefaultUnlit"
            }

            Blend [_SrcBlendMode] [_DstBlendMode]
            BlendOp [_BlendOp]
            ZWrite [_Zwrite]
            ZTest [_Ztest]
            Cull [_Cull]

            HLSLPROGRAM
 
            #pragma vertex DistortionNewMainVertex
            #pragma fragment DistortionNewMainFragment
            #include "./nx/Distortion_NewInput.hlsl"
            #include "./nx/Distortion_NewPass.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "DISTORTIONVECTORS"
            Tags
            {
                // to fix
                "LightMode" = "UniversalForward"
            }

            Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Off

            HLSLPROGRAM
 
            #pragma vertex DistortionNewVertex
            #pragma fragment DistortionNewFragment
            #include "./nx/Distortion_NewInput.hlsl"
            #include "./nx/Distortion_NewPass.hlsl"

            ENDHLSL
        }
    }
}
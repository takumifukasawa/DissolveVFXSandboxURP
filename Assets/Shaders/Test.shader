Shader "PBR Master / Test"
{
    Properties
    {
        Vector1_E878C15C("Rate", Float) = 0
        Vector1_9AEE82B7("EdgeFadeIn", Float) = 0.35
        Vector1_8520E192("EdgeIn", Float) = 0.45
        Vector1_6E4EF989("EdgeOut", Float) = 0.55
        Vector1_DCD98("EdgeFadeOut", Float) = 0.65
        Color_53B64128("Albedo", Color) = (1, 1, 1, 0)
        [HDR]Color_365AD219("EdgeColor", Color) = (0, 1.6, 2, 0)
        // [NonModifiableTextureData][NoScaleOffset]_SampleTexture2D_80D190B3_Texture_1("Texture2D", 2D) = "white" {}
        _SampleTexture2D_80D190B3_Texture_1("Texture2D", 2D) = "white" {}
    }
    SubShader
    {
        Tags
    {
        "RenderPipeline"="UniversalPipeline"
        "RenderType"="Transparent"
        "Queue"="Transparent+0"
    }

        Pass
    {
        Name "Universal Forward"
        Tags 
        { 
            "LightMode" = "UniversalForward"
        }
       
        // Render State
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        Cull Back
        ZTest LEqual
        ZWrite Off
        // ColorMask: <None>
        

        HLSLPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        // Pragmas
        #pragma prefer_hlslcc gles
    #pragma exclude_renderers d3d11_9x
    #pragma target 2.0
    #pragma multi_compile_fog
    #pragma multi_compile_instancing

        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
    #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
    #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
    #pragma multi_compile _ _SHADOWS_SOFT
    #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        // GraphKeywords: <None>
        
        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS 
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define SHADERPASS_FORWARD

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

        // --------------------------------------------------
        // Graph

        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
    float Vector1_E878C15C;
    float Vector1_9AEE82B7;
    float Vector1_8520E192;
    float Vector1_6E4EF989;
    float Vector1_DCD98;
    float4 Color_53B64128;
    float4 Color_365AD219;
    CBUFFER_END
    TEXTURE2D(_SampleTexture2D_80D190B3_Texture_1); SAMPLER(sampler_SampleTexture2D_80D190B3_Texture_1); float4 _SampleTexture2D_80D190B3_Texture_1_TexelSize;
    SAMPLER(_SampleTexture2D_80D190B3_Sampler_3_Linear_Repeat);

        // Graph Functions
        
    void Unity_Saturate_float(float In, out float Out)
    {
        Out = saturate(In);
    }

    void Unity_Subtract_float(float A, float B, out float Out)
    {
        Out = A - B;
    }

    void Unity_Lerp_float(float A, float B, float T, out float Out)
    {
        Out = lerp(A, B, T);
    }

    void Unity_Add_float(float A, float B, out float Out)
    {
        Out = A + B;
    }

    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
    {
        Out = smoothstep(Edge1, Edge2, In);
    }

    void Unity_OneMinus_float(float In, out float Out)
    {
        Out = 1 - In;
    }

    void Unity_Multiply_float(float A, float B, out float Out)
    {
        Out = A * B;
    }

    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
    {
        Out = lerp(A, B, T);
    }

        // Graph Vertex
        // GraphVertex: <None>
        
        // Graph Pixel
        struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float4 uv0;
    };

    struct SurfaceDescription
    {
        float3 Albedo;
        float3 Normal;
        float3 Emission;
        float Metallic;
        float Smoothness;
        float Occlusion;
        float Alpha;
        float AlphaClipThreshold;
    };

    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
    {
        SurfaceDescription surface = (SurfaceDescription)0;
        float4 _Property_5DFA3944_Out_0 = Color_53B64128;
        float4 Color_DC3C44A0 = IsGammaSpace() ? float4(0, 0, 0, 0) : float4(SRGBToLinear(float3(0, 0, 0)), 0);
        float4 _Property_2B54F15A_Out_0 = Color_365AD219;
        float _Property_CC105FFB_Out_0 = Vector1_9AEE82B7;
        float _Property_82E0C662_Out_0 = Vector1_8520E192;
        float4 _SampleTexture2D_80D190B3_RGBA_0 = SAMPLE_TEXTURE2D(_SampleTexture2D_80D190B3_Texture_1, sampler_SampleTexture2D_80D190B3_Texture_1, IN.uv0.xy);
        float _SampleTexture2D_80D190B3_R_4 = _SampleTexture2D_80D190B3_RGBA_0.r;
        float _SampleTexture2D_80D190B3_G_5 = _SampleTexture2D_80D190B3_RGBA_0.g;
        float _SampleTexture2D_80D190B3_B_6 = _SampleTexture2D_80D190B3_RGBA_0.b;
        float _SampleTexture2D_80D190B3_A_7 = _SampleTexture2D_80D190B3_RGBA_0.a;
        float _Saturate_87070DF3_Out_1;
        Unity_Saturate_float(_SampleTexture2D_80D190B3_R_4, _Saturate_87070DF3_Out_1);
        float _Subtract_39232414_Out_2;
        Unity_Subtract_float(_Saturate_87070DF3_Out_1, 1, _Subtract_39232414_Out_2);
        float _Property_677CE51_Out_0 = Vector1_E878C15C;
        float _Saturate_76832642_Out_1;
        Unity_Saturate_float(_Property_677CE51_Out_0, _Saturate_76832642_Out_1);
        float _Lerp_77A56951_Out_3;
        Unity_Lerp_float(0, 2, _Saturate_76832642_Out_1, _Lerp_77A56951_Out_3);
        float _Add_7F7BBE5B_Out_2;
        Unity_Add_float(_Subtract_39232414_Out_2, _Lerp_77A56951_Out_3, _Add_7F7BBE5B_Out_2);
        float _Smoothstep_2DBECEB2_Out_3;
        Unity_Smoothstep_float(_Property_CC105FFB_Out_0, _Property_82E0C662_Out_0, _Add_7F7BBE5B_Out_2, _Smoothstep_2DBECEB2_Out_3);
        float _Property_A290E1F9_Out_0 = Vector1_6E4EF989;
        float _Property_F8EA941E_Out_0 = Vector1_DCD98;
        float _Smoothstep_619DA164_Out_3;
        Unity_Smoothstep_float(_Property_A290E1F9_Out_0, _Property_F8EA941E_Out_0, _Add_7F7BBE5B_Out_2, _Smoothstep_619DA164_Out_3);
        float _OneMinus_A21C0C6F_Out_1;
        Unity_OneMinus_float(_Smoothstep_619DA164_Out_3, _OneMinus_A21C0C6F_Out_1);
        float _Multiply_ECD41105_Out_2;
        Unity_Multiply_float(_Smoothstep_2DBECEB2_Out_3, _OneMinus_A21C0C6F_Out_1, _Multiply_ECD41105_Out_2);
        float4 _Lerp_C3A41187_Out_3;
        Unity_Lerp_float4(Color_DC3C44A0, _Property_2B54F15A_Out_0, (_Multiply_ECD41105_Out_2.xxxx), _Lerp_C3A41187_Out_3);
        surface.Albedo = (_Property_5DFA3944_Out_0.xyz);
        surface.Normal = IN.TangentSpaceNormal;
        surface.Emission = (_Lerp_C3A41187_Out_3.xyz);
        surface.Metallic = 0;
        surface.Smoothness = 0.5;
        surface.Occlusion = 1;
        surface.Alpha = _Smoothstep_619DA164_Out_3;
        surface.AlphaClipThreshold = 0;
        return surface;
    }

        // --------------------------------------------------
        // Structs and Packing

        // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };

        // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                float4 tangentWS;
                float4 texCoord0;
                float3 viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                float2 lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                float3 sh;
                #endif
                float4 fogFactorAndVertexLight;
                float4 shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if defined(LIGHTMAP_ON)
                #endif
                #if !defined(LIGHTMAP_ON)
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float4 interp02 : TEXCOORD2;
                float4 interp03 : TEXCOORD3;
                float3 interp04 : TEXCOORD4;
                float2 interp05 : TEXCOORD5;
                float3 interp06 : TEXCOORD6;
                float4 interp07 : TEXCOORD7;
                float4 interp08 : TEXCOORD8;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                output.interp03.xyzw = input.texCoord0;
                output.interp04.xyz = input.viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                output.interp05.xy = input.lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.interp06.xyz = input.sh;
                #endif
                output.interp07.xyzw = input.fogFactorAndVertexLight;
                output.interp08.xyzw = input.shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                output.texCoord0 = input.interp03.xyzw;
                output.viewDirectionWS = input.interp04.xyz;
                #if defined(LIGHTMAP_ON)
                output.lightmapUV = input.interp05.xy;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.sh = input.interp06.xyz;
                #endif
                output.fogFactorAndVertexLight = input.interp07.xyzw;
                output.shadowCoord = input.interp08.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

        // --------------------------------------------------
        // Build Graph Inputs

        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


        output.uv0 =                         input.texCoord0;
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
    }

        // --------------------------------------------------
        // Main

        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

        ENDHLSL
    }

        Pass
    {
        Name "ShadowCaster"
        Tags 
        { 
            "LightMode" = "ShadowCaster"
        }
       
        // Render State
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        

        HLSLPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        // Pragmas
        #pragma prefer_hlslcc gles
    #pragma exclude_renderers d3d11_9x
    #pragma target 2.0
    #pragma multi_compile_instancing

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define SHADERPASS_SHADOWCASTER

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

        // --------------------------------------------------
        // Graph

        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
    float Vector1_E878C15C;
    float Vector1_9AEE82B7;
    float Vector1_8520E192;
    float Vector1_6E4EF989;
    float Vector1_DCD98;
    float4 Color_53B64128;
    float4 Color_365AD219;
    CBUFFER_END
    TEXTURE2D(_SampleTexture2D_80D190B3_Texture_1); SAMPLER(sampler_SampleTexture2D_80D190B3_Texture_1); float4 _SampleTexture2D_80D190B3_Texture_1_TexelSize;
    SAMPLER(_SampleTexture2D_80D190B3_Sampler_3_Linear_Repeat);

        // Graph Functions
        
    void Unity_Saturate_float(float In, out float Out)
    {
        Out = saturate(In);
    }

    void Unity_Subtract_float(float A, float B, out float Out)
    {
        Out = A - B;
    }

    void Unity_Lerp_float(float A, float B, float T, out float Out)
    {
        Out = lerp(A, B, T);
    }

    void Unity_Add_float(float A, float B, out float Out)
    {
        Out = A + B;
    }

    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
    {
        Out = smoothstep(Edge1, Edge2, In);
    }

        // Graph Vertex
        // GraphVertex: <None>
        
        // Graph Pixel
        struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float4 uv0;
    };

    struct SurfaceDescription
    {
        float Alpha;
        float AlphaClipThreshold;
    };

    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
    {
        SurfaceDescription surface = (SurfaceDescription)0;
        float _Property_A290E1F9_Out_0 = Vector1_6E4EF989;
        float _Property_F8EA941E_Out_0 = Vector1_DCD98;
        float4 _SampleTexture2D_80D190B3_RGBA_0 = SAMPLE_TEXTURE2D(_SampleTexture2D_80D190B3_Texture_1, sampler_SampleTexture2D_80D190B3_Texture_1, IN.uv0.xy);
        float _SampleTexture2D_80D190B3_R_4 = _SampleTexture2D_80D190B3_RGBA_0.r;
        float _SampleTexture2D_80D190B3_G_5 = _SampleTexture2D_80D190B3_RGBA_0.g;
        float _SampleTexture2D_80D190B3_B_6 = _SampleTexture2D_80D190B3_RGBA_0.b;
        float _SampleTexture2D_80D190B3_A_7 = _SampleTexture2D_80D190B3_RGBA_0.a;
        float _Saturate_87070DF3_Out_1;
        Unity_Saturate_float(_SampleTexture2D_80D190B3_R_4, _Saturate_87070DF3_Out_1);
        float _Subtract_39232414_Out_2;
        Unity_Subtract_float(_Saturate_87070DF3_Out_1, 1, _Subtract_39232414_Out_2);
        float _Property_677CE51_Out_0 = Vector1_E878C15C;
        float _Saturate_76832642_Out_1;
        Unity_Saturate_float(_Property_677CE51_Out_0, _Saturate_76832642_Out_1);
        float _Lerp_77A56951_Out_3;
        Unity_Lerp_float(0, 2, _Saturate_76832642_Out_1, _Lerp_77A56951_Out_3);
        float _Add_7F7BBE5B_Out_2;
        Unity_Add_float(_Subtract_39232414_Out_2, _Lerp_77A56951_Out_3, _Add_7F7BBE5B_Out_2);
        float _Smoothstep_619DA164_Out_3;
        Unity_Smoothstep_float(_Property_A290E1F9_Out_0, _Property_F8EA941E_Out_0, _Add_7F7BBE5B_Out_2, _Smoothstep_619DA164_Out_3);
        surface.Alpha = _Smoothstep_619DA164_Out_3;
        surface.AlphaClipThreshold = 0;
        return surface;
    }

        // --------------------------------------------------
        // Structs and Packing

        // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };

        // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float4 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyzw = input.texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.texCoord0 = input.interp00.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

        // --------------------------------------------------
        // Build Graph Inputs

        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


        output.uv0 =                         input.texCoord0;
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
    }

        // --------------------------------------------------
        // Main

        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

        ENDHLSL
    }

        Pass
    {
        Name "DepthOnly"
        Tags 
        { 
            "LightMode" = "DepthOnly"
        }
       
        // Render State
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        

        HLSLPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        // Pragmas
        #pragma prefer_hlslcc gles
    #pragma exclude_renderers d3d11_9x
    #pragma target 2.0
    #pragma multi_compile_instancing

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define SHADERPASS_DEPTHONLY

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

        // --------------------------------------------------
        // Graph

        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
    float Vector1_E878C15C;
    float Vector1_9AEE82B7;
    float Vector1_8520E192;
    float Vector1_6E4EF989;
    float Vector1_DCD98;
    float4 Color_53B64128;
    float4 Color_365AD219;
    CBUFFER_END
    TEXTURE2D(_SampleTexture2D_80D190B3_Texture_1); SAMPLER(sampler_SampleTexture2D_80D190B3_Texture_1); float4 _SampleTexture2D_80D190B3_Texture_1_TexelSize;
    SAMPLER(_SampleTexture2D_80D190B3_Sampler_3_Linear_Repeat);

        // Graph Functions
        
    void Unity_Saturate_float(float In, out float Out)
    {
        Out = saturate(In);
    }

    void Unity_Subtract_float(float A, float B, out float Out)
    {
        Out = A - B;
    }

    void Unity_Lerp_float(float A, float B, float T, out float Out)
    {
        Out = lerp(A, B, T);
    }

    void Unity_Add_float(float A, float B, out float Out)
    {
        Out = A + B;
    }

    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
    {
        Out = smoothstep(Edge1, Edge2, In);
    }

        // Graph Vertex
        // GraphVertex: <None>
        
        // Graph Pixel
        struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float4 uv0;
    };

    struct SurfaceDescription
    {
        float Alpha;
        float AlphaClipThreshold;
    };

    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
    {
        SurfaceDescription surface = (SurfaceDescription)0;
        float _Property_A290E1F9_Out_0 = Vector1_6E4EF989;
        float _Property_F8EA941E_Out_0 = Vector1_DCD98;
        float4 _SampleTexture2D_80D190B3_RGBA_0 = SAMPLE_TEXTURE2D(_SampleTexture2D_80D190B3_Texture_1, sampler_SampleTexture2D_80D190B3_Texture_1, IN.uv0.xy);
        float _SampleTexture2D_80D190B3_R_4 = _SampleTexture2D_80D190B3_RGBA_0.r;
        float _SampleTexture2D_80D190B3_G_5 = _SampleTexture2D_80D190B3_RGBA_0.g;
        float _SampleTexture2D_80D190B3_B_6 = _SampleTexture2D_80D190B3_RGBA_0.b;
        float _SampleTexture2D_80D190B3_A_7 = _SampleTexture2D_80D190B3_RGBA_0.a;
        float _Saturate_87070DF3_Out_1;
        Unity_Saturate_float(_SampleTexture2D_80D190B3_R_4, _Saturate_87070DF3_Out_1);
        float _Subtract_39232414_Out_2;
        Unity_Subtract_float(_Saturate_87070DF3_Out_1, 1, _Subtract_39232414_Out_2);
        float _Property_677CE51_Out_0 = Vector1_E878C15C;
        float _Saturate_76832642_Out_1;
        Unity_Saturate_float(_Property_677CE51_Out_0, _Saturate_76832642_Out_1);
        float _Lerp_77A56951_Out_3;
        Unity_Lerp_float(0, 2, _Saturate_76832642_Out_1, _Lerp_77A56951_Out_3);
        float _Add_7F7BBE5B_Out_2;
        Unity_Add_float(_Subtract_39232414_Out_2, _Lerp_77A56951_Out_3, _Add_7F7BBE5B_Out_2);
        float _Smoothstep_619DA164_Out_3;
        Unity_Smoothstep_float(_Property_A290E1F9_Out_0, _Property_F8EA941E_Out_0, _Add_7F7BBE5B_Out_2, _Smoothstep_619DA164_Out_3);
        surface.Alpha = _Smoothstep_619DA164_Out_3;
        surface.AlphaClipThreshold = 0;
        return surface;
    }

        // --------------------------------------------------
        // Structs and Packing

        // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };

        // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float4 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyzw = input.texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.texCoord0 = input.interp00.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

        // --------------------------------------------------
        // Build Graph Inputs

        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


        output.uv0 =                         input.texCoord0;
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
    }

        // --------------------------------------------------
        // Main

        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

        ENDHLSL
    }

        Pass
    {
        Name "Meta"
        Tags 
        { 
            "LightMode" = "Meta"
        }
       
        // Render State
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        Cull Off
        ZTest LEqual
        ZWrite Off
        // ColorMask: <None>
        

        HLSLPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        // Pragmas
        #pragma prefer_hlslcc gles
    #pragma exclude_renderers d3d11_9x
    #pragma target 2.0

        // Keywords
        #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
        // GraphKeywords: <None>
        
        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_TEXCOORD0
        #define SHADERPASS_META

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
    #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

        // --------------------------------------------------
        // Graph

        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
    float Vector1_E878C15C;
    float Vector1_9AEE82B7;
    float Vector1_8520E192;
    float Vector1_6E4EF989;
    float Vector1_DCD98;
    float4 Color_53B64128;
    float4 Color_365AD219;
    CBUFFER_END
    TEXTURE2D(_SampleTexture2D_80D190B3_Texture_1); SAMPLER(sampler_SampleTexture2D_80D190B3_Texture_1); float4 _SampleTexture2D_80D190B3_Texture_1_TexelSize;
    SAMPLER(_SampleTexture2D_80D190B3_Sampler_3_Linear_Repeat);

        // Graph Functions
        
    void Unity_Saturate_float(float In, out float Out)
    {
        Out = saturate(In);
    }

    void Unity_Subtract_float(float A, float B, out float Out)
    {
        Out = A - B;
    }

    void Unity_Lerp_float(float A, float B, float T, out float Out)
    {
        Out = lerp(A, B, T);
    }

    void Unity_Add_float(float A, float B, out float Out)
    {
        Out = A + B;
    }

    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
    {
        Out = smoothstep(Edge1, Edge2, In);
    }

    void Unity_OneMinus_float(float In, out float Out)
    {
        Out = 1 - In;
    }

    void Unity_Multiply_float(float A, float B, out float Out)
    {
        Out = A * B;
    }

    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
    {
        Out = lerp(A, B, T);
    }

        // Graph Vertex
        // GraphVertex: <None>
        
        // Graph Pixel
        struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float4 uv0;
    };

    struct SurfaceDescription
    {
        float3 Albedo;
        float3 Emission;
        float Alpha;
        float AlphaClipThreshold;
    };

    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
    {
        SurfaceDescription surface = (SurfaceDescription)0;
        float4 _Property_5DFA3944_Out_0 = Color_53B64128;
        float4 Color_DC3C44A0 = IsGammaSpace() ? float4(0, 0, 0, 0) : float4(SRGBToLinear(float3(0, 0, 0)), 0);
        float4 _Property_2B54F15A_Out_0 = Color_365AD219;
        float _Property_CC105FFB_Out_0 = Vector1_9AEE82B7;
        float _Property_82E0C662_Out_0 = Vector1_8520E192;
        float4 _SampleTexture2D_80D190B3_RGBA_0 = SAMPLE_TEXTURE2D(_SampleTexture2D_80D190B3_Texture_1, sampler_SampleTexture2D_80D190B3_Texture_1, IN.uv0.xy);
        float _SampleTexture2D_80D190B3_R_4 = _SampleTexture2D_80D190B3_RGBA_0.r;
        float _SampleTexture2D_80D190B3_G_5 = _SampleTexture2D_80D190B3_RGBA_0.g;
        float _SampleTexture2D_80D190B3_B_6 = _SampleTexture2D_80D190B3_RGBA_0.b;
        float _SampleTexture2D_80D190B3_A_7 = _SampleTexture2D_80D190B3_RGBA_0.a;
        float _Saturate_87070DF3_Out_1;
        Unity_Saturate_float(_SampleTexture2D_80D190B3_R_4, _Saturate_87070DF3_Out_1);
        float _Subtract_39232414_Out_2;
        Unity_Subtract_float(_Saturate_87070DF3_Out_1, 1, _Subtract_39232414_Out_2);
        float _Property_677CE51_Out_0 = Vector1_E878C15C;
        float _Saturate_76832642_Out_1;
        Unity_Saturate_float(_Property_677CE51_Out_0, _Saturate_76832642_Out_1);
        float _Lerp_77A56951_Out_3;
        Unity_Lerp_float(0, 2, _Saturate_76832642_Out_1, _Lerp_77A56951_Out_3);
        float _Add_7F7BBE5B_Out_2;
        Unity_Add_float(_Subtract_39232414_Out_2, _Lerp_77A56951_Out_3, _Add_7F7BBE5B_Out_2);
        float _Smoothstep_2DBECEB2_Out_3;
        Unity_Smoothstep_float(_Property_CC105FFB_Out_0, _Property_82E0C662_Out_0, _Add_7F7BBE5B_Out_2, _Smoothstep_2DBECEB2_Out_3);
        float _Property_A290E1F9_Out_0 = Vector1_6E4EF989;
        float _Property_F8EA941E_Out_0 = Vector1_DCD98;
        float _Smoothstep_619DA164_Out_3;
        Unity_Smoothstep_float(_Property_A290E1F9_Out_0, _Property_F8EA941E_Out_0, _Add_7F7BBE5B_Out_2, _Smoothstep_619DA164_Out_3);
        float _OneMinus_A21C0C6F_Out_1;
        Unity_OneMinus_float(_Smoothstep_619DA164_Out_3, _OneMinus_A21C0C6F_Out_1);
        float _Multiply_ECD41105_Out_2;
        Unity_Multiply_float(_Smoothstep_2DBECEB2_Out_3, _OneMinus_A21C0C6F_Out_1, _Multiply_ECD41105_Out_2);
        float4 _Lerp_C3A41187_Out_3;
        Unity_Lerp_float4(Color_DC3C44A0, _Property_2B54F15A_Out_0, (_Multiply_ECD41105_Out_2.xxxx), _Lerp_C3A41187_Out_3);
        surface.Albedo = (_Property_5DFA3944_Out_0.xyz);
        surface.Emission = (_Lerp_C3A41187_Out_3.xyz);
        surface.Alpha = _Smoothstep_619DA164_Out_3;
        surface.AlphaClipThreshold = 0;
        return surface;
    }

        // --------------------------------------------------
        // Structs and Packing

        // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                float4 uv2 : TEXCOORD2;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };

        // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float4 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyzw = input.texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.texCoord0 = input.interp00.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

        // --------------------------------------------------
        // Build Graph Inputs

        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


        output.uv0 =                         input.texCoord0;
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
    }

        // --------------------------------------------------
        // Main

        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

        ENDHLSL
    }

        Pass
    {
        // Name: <None>
        Tags 
        { 
            "LightMode" = "Universal2D"
        }
       
        // Render State
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        Cull Back
        ZTest LEqual
        ZWrite Off
        // ColorMask: <None>
        

        HLSLPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        // Pragmas
        #pragma prefer_hlslcc gles
    #pragma exclude_renderers d3d11_9x
    #pragma target 2.0
    #pragma multi_compile_instancing

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define SHADERPASS_2D

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

        // --------------------------------------------------
        // Graph

        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
    float Vector1_E878C15C;
    float Vector1_9AEE82B7;
    float Vector1_8520E192;
    float Vector1_6E4EF989;
    float Vector1_DCD98;
    float4 Color_53B64128;
    float4 Color_365AD219;
    CBUFFER_END
    TEXTURE2D(_SampleTexture2D_80D190B3_Texture_1); SAMPLER(sampler_SampleTexture2D_80D190B3_Texture_1); float4 _SampleTexture2D_80D190B3_Texture_1_TexelSize;
    SAMPLER(_SampleTexture2D_80D190B3_Sampler_3_Linear_Repeat);

        // Graph Functions
        
    void Unity_Saturate_float(float In, out float Out)
    {
        Out = saturate(In);
    }

    void Unity_Subtract_float(float A, float B, out float Out)
    {
        Out = A - B;
    }

    void Unity_Lerp_float(float A, float B, float T, out float Out)
    {
        Out = lerp(A, B, T);
    }

    void Unity_Add_float(float A, float B, out float Out)
    {
        Out = A + B;
    }

    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
    {
        Out = smoothstep(Edge1, Edge2, In);
    }

        // Graph Vertex
        // GraphVertex: <None>
        
        // Graph Pixel
        struct SurfaceDescriptionInputs
    {
        float3 TangentSpaceNormal;
        float4 uv0;
    };

    struct SurfaceDescription
    {
        float3 Albedo;
        float Alpha;
        float AlphaClipThreshold;
    };

    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
    {
        SurfaceDescription surface = (SurfaceDescription)0;
        float4 _Property_5DFA3944_Out_0 = Color_53B64128;
        float _Property_A290E1F9_Out_0 = Vector1_6E4EF989;
        float _Property_F8EA941E_Out_0 = Vector1_DCD98;
        float4 _SampleTexture2D_80D190B3_RGBA_0 = SAMPLE_TEXTURE2D(_SampleTexture2D_80D190B3_Texture_1, sampler_SampleTexture2D_80D190B3_Texture_1, IN.uv0.xy);
        float _SampleTexture2D_80D190B3_R_4 = _SampleTexture2D_80D190B3_RGBA_0.r;
        float _SampleTexture2D_80D190B3_G_5 = _SampleTexture2D_80D190B3_RGBA_0.g;
        float _SampleTexture2D_80D190B3_B_6 = _SampleTexture2D_80D190B3_RGBA_0.b;
        float _SampleTexture2D_80D190B3_A_7 = _SampleTexture2D_80D190B3_RGBA_0.a;
        float _Saturate_87070DF3_Out_1;
        Unity_Saturate_float(_SampleTexture2D_80D190B3_R_4, _Saturate_87070DF3_Out_1);
        float _Subtract_39232414_Out_2;
        Unity_Subtract_float(_Saturate_87070DF3_Out_1, 1, _Subtract_39232414_Out_2);
        float _Property_677CE51_Out_0 = Vector1_E878C15C;
        float _Saturate_76832642_Out_1;
        Unity_Saturate_float(_Property_677CE51_Out_0, _Saturate_76832642_Out_1);
        float _Lerp_77A56951_Out_3;
        Unity_Lerp_float(0, 2, _Saturate_76832642_Out_1, _Lerp_77A56951_Out_3);
        float _Add_7F7BBE5B_Out_2;
        Unity_Add_float(_Subtract_39232414_Out_2, _Lerp_77A56951_Out_3, _Add_7F7BBE5B_Out_2);
        float _Smoothstep_619DA164_Out_3;
        Unity_Smoothstep_float(_Property_A290E1F9_Out_0, _Property_F8EA941E_Out_0, _Add_7F7BBE5B_Out_2, _Smoothstep_619DA164_Out_3);
        surface.Albedo = (_Property_5DFA3944_Out_0.xyz);
        surface.Alpha = _Smoothstep_619DA164_Out_3;
        surface.AlphaClipThreshold = 0;
        return surface;
    }

        // --------------------------------------------------
        // Structs and Packing

        // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };

        // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float4 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyzw = input.texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.texCoord0 = input.interp00.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

        // --------------------------------------------------
        // Build Graph Inputs

        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
    {
        SurfaceDescriptionInputs output;
        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


        output.uv0 =                         input.texCoord0;
    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
    #else
    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
    #endif
    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
    }

        // --------------------------------------------------
        // Main

        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

        ENDHLSL
    }

    }
    CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}

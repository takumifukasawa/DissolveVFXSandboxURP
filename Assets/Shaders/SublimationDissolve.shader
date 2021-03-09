Shader "Universal Render Pipeline/SublimationDissolve"
{
    Properties
    {
        // Specular vs Metallic workflow
        [HideInInspector] _WorkflowMode("WorkflowMode", Float) = 1.0

        [MainTexture] _BaseMap("Albedo", 2D) = "white" {}
        [MainColor] _BaseColor("Color", Color) = (1,1,1,1)

        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

        _Smoothness("Smoothness", Range(0.0, 1.0)) = 0.5
        _GlossMapScale("Smoothness Scale", Range(0.0, 1.0)) = 1.0
        _SmoothnessTextureChannel("Smoothness texture channel", Float) = 0

        _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
        _MetallicGlossMap("Metallic", 2D) = "white" {}

        _SpecColor("Specular", Color) = (0.2, 0.2, 0.2)
        _SpecGlossMap("Specular", 2D) = "white" {}

        [ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
        [ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0

        _BumpScale("Scale", Float) = 1.0
        _BumpMap("Normal Map", 2D) = "bump" {}

        _OcclusionStrength("Strength", Range(0.0, 1.0)) = 1.0
        _OcclusionMap("Occlusion", 2D) = "white" {}

        _EmissionColor("Color", Color) = (0,0,0)
        _EmissionMap("Emission", 2D) = "white" {}

        // Sublimation Dissolve
        _DissolveMap("Dissolve Map", 2D) = "white" {}
        _DissolveRate("Dissolve Rate", Range(0.0, 1.0)) = 0.0
        [HDR] _DissolveEdgeEmissionColor("Dissolve Edge Emission Color", Color) = (1, 1, 1, 1)
        _DissolveEdgeFadeIn("Dissolve Edge Fade In", Range(0.0, 1.0)) = 0.35
        _DissolveEdgeIn("Dissolve Edge In", Range(0.0, 1.0)) = 0.45
        _DissolveEdgeOut("Dissolev Edge Out", Range(0.0, 1.0)) = 0.55
        _DissolveEdgeFadeOut("Dissolve Edge Fade Out", Range(0.0, 1.0)) = 0.65

        // Blending state
        [HideInInspector] _Surface("__surface", Float) = 0.0
        [HideInInspector] _Blend("__blend", Float) = 0.0
        [HideInInspector] _AlphaClip("__clip", Float) = 0.0
        [HideInInspector] _SrcBlend("__src", Float) = 1.0
        [HideInInspector] _DstBlend("__dst", Float) = 0.0
        [HideInInspector] _ZWrite("__zw", Float) = 1.0
        [HideInInspector] _Cull("__cull", Float) = 2.0

        _ReceiveShadows("Receive Shadows", Float) = 1.0
        // Editmode props
        [HideInInspector] _QueueOffset("Queue offset", Float) = 0.0

        // ObsoleteProperties
        [HideInInspector] _MainTex("BaseMap", 2D) = "white" {}
        [HideInInspector] _Color("Base Color", Color) = (1, 1, 1, 1)
        [HideInInspector] _GlossMapScale("Smoothness", Float) = 0.0
        [HideInInspector] _Glossiness("Smoothness", Float) = 0.0
        [HideInInspector] _GlossyReflections("EnvironmentReflections", Float) = 0.0
    }

    SubShader
    {
        // Universal Pipeline tag is required. If Universal render pipeline is not set in the graphics settings
        // this Subshader will fail. One can add a subshader below or fallback to Standard built-in to make this
        // material work with both Universal Render Pipeline and Builtin Unity Pipeline
        Tags{"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "IgnoreProjector" = "True"}
        LOD 300

        // ------------------------------------------------------------------
        //  Forward pass. Shades all light in a single pass. GI + emission + Fog
        Pass
        {
            // Lightmode matches the ShaderPassName set in UniversalRenderPipeline.cs. SRPDefaultUnlit and passes with
            // no LightMode tag are also rendered by Universal Render Pipeline
            Name "ForwardLit"
            Tags{"LightMode" = "UniversalForward"}

            Blend[_SrcBlend][_DstBlend]
            ZWrite[_ZWrite]
            Cull[_Cull]

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard SRP library
            // All shaders must be compiled with HLSLcc and currently only gles is not using HLSLcc by default
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

            // #pragma target 2.0
            #pragma target 4.5

            #pragma require geometry

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature _NORMALMAP
            #pragma shader_feature _ALPHATEST_ON
            #pragma shader_feature _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _EMISSION
            #pragma shader_feature _METALLICSPECGLOSSMAP
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature _OCCLUSIONMAP

            #pragma shader_feature _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature _ENVIRONMENTREFLECTIONS_OFF
            #pragma shader_feature _SPECULAR_SETUP
            #pragma shader_feature _RECEIVE_SHADOWS_OFF

            // -------------------------------------
            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile_fog

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex SublimationDissolveLitVertex
            #pragma geometry SublimationDissolveLitGeometry
            #pragma fragment SublimationDissolveLitFragment

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitForwardPass.hlsl"

            sampler2D _DissolveMap;
            float4 _DissolveMap_ST;
            float _DissolveRate;
            half4 _DissolveEdgeEmissionColor;
            float _DissolveEdgeFadeIn;
            float _DissolveEdgeIn;
            float _DissolveEdgeOut;
            float _DissolveEdgeFadeOut;

            struct SublimationDissolveAttributes
            {
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
                float4 tangentOS    : TANGENT;
                float2 texcoord     : TEXCOORD0;
                float2 lightmapUV   : TEXCOORD1;
                float2 dissolveUV   : TEXCOORD2;
                float dissolveRate  : TEXCOORD3;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            struct SublimationDissolveVaryings
            {
                float2 uv                       : TEXCOORD0;
                DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 1);

            #if defined(REQUIRES_WORLD_SPACE_POS_INTERPOLATOR)
                float3 positionWS               : TEXCOORD2;
            #endif

                float3 normalWS                 : TEXCOORD3;
            #ifdef _NORMALMAP
                float4 tangentWS                : TEXCOORD4;    // xyz: tangent, w: sign
            #endif
                float3 viewDirWS                : TEXCOORD5;

                half4 fogFactorAndVertexLight   : TEXCOORD6; // x: fogFactor, yzw: vertex light

            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                float4 shadowCoord              : TEXCOORD7;
            #endif

                float4 positionCS               : SV_POSITION;
                float2 dissolveUV               : TEXCOORD8;
                float dissolveRate              : TEXCOORD9;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            void SublimationDissolveInitializeInputData(SublimationDissolveVaryings input, half3 normalTS, out InputData inputData)
            {
                inputData = (InputData)0;

            #if defined(REQUIRES_WORLD_SPACE_POS_INTERPOLATOR)
                inputData.positionWS = input.positionWS;
            #endif

                half3 viewDirWS = SafeNormalize(input.viewDirWS);
            #ifdef _NORMALMAP
                float sgn = input.tangentWS.w;      // should be either +1 or -1
                float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                inputData.normalWS = TransformTangentToWorld(normalTS, half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz));
            #else
                inputData.normalWS = input.normalWS;
            #endif

                inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
                inputData.viewDirectionWS = viewDirWS;

            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                inputData.shadowCoord = input.shadowCoord;
            #elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
                inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
            #else
                inputData.shadowCoord = float4(0, 0, 0, 0);
            #endif

                inputData.fogCoord = input.fogFactorAndVertexLight.x;
                inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
                inputData.bakedGI = SAMPLE_GI(input.lightmapUV, input.vertexSH, inputData.normalWS);
            }

            // Used in Standard (Physically Based) shader
            SublimationDissolveAttributes SublimationDissolveLitVertex(Attributes input)
            {
                SublimationDissolveAttributes output;
                output.positionOS = input.positionOS;
                output.normalOS = input.normalOS;
                output.tangentOS = input.tangentOS;
                output.texcoord = input.texcoord;
                output.lightmapUV = input.lightmapUV;

                float2 dissolveUV = TRANSFORM_TEX(input.texcoord, _DissolveMap);
                output.dissolveUV = dissolveUV;
                float dissolveRate = tex2Dlod(_DissolveMap, float4(dissolveUV, 0, 0)).r;
                output.dissolveRate = dissolveRate;

                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);
 
                return output;
            //     SublimationDissolveVaryings output = (SublimationDissolveVaryings)0;

            //     UNITY_SETUP_INSTANCE_ID(input);
            //     UNITY_TRANSFER_INSTANCE_ID(input, output);
            //     UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

            //     VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);

            //     // normalWS and tangentWS already normalize.
            //     // this is required to avoid skewing the direction during interpolation
            //     // also required for per-vertex lighting and SH evaluation
            //     VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);
            //     float3 viewDirWS = GetCameraPositionWS() - vertexInput.positionWS;
            //     half3 vertexLight = VertexLighting(vertexInput.positionWS, normalInput.normalWS);
            //     half fogFactor = ComputeFogFactor(vertexInput.positionCS.z);

            //     output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);

            //     output.dissolveUV = TRANSFORM_TEX(input.texcoord, _DissolveMap);

            //     // already normalized from normal transform to WS.
            //     output.normalWS = normalInput.normalWS;
            //     output.viewDirWS = viewDirWS;
            // #ifdef _NORMALMAP
            //     real sign = input.tangentOS.w * GetOddNegativeScale();
            //     output.tangentWS = half4(normalInput.tangentWS.xyz, sign);
            // #endif

            //     OUTPUT_LIGHTMAP_UV(input.lightmapUV, unity_LightmapST, output.lightmapUV);
            //     OUTPUT_SH(output.normalWS.xyz, output.vertexSH);

            //     output.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

            // #if defined(REQUIRES_WORLD_SPACE_POS_INTERPOLATOR)
            //     output.positionWS = vertexInput.positionWS;
            // #endif

            // #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            //     output.shadowCoord = GetShadowCoord(vertexInput);
            // #endif

            //     output.positionCS = vertexInput.positionCS;

            //     return output;
            }

            SublimationDissolveVaryings createVaryings(SublimationDissolveAttributes input, float3 proxyVertexPosition, float3 vertexOffset, float dissolveRate) {
                SublimationDissolveVaryings output = (SublimationDissolveVaryings)0;

                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

                output.dissolveRate = dissolveRate;

                // float3 vertexPosition = input.positionOS.xyz + vertexOffset + input.normalOS * _DissolveRate * 2;
                float3 vertexPosition = proxyVertexPosition + vertexOffset;

                // VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                // VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz + input.normalOS * _DissolveRate * 2);
                VertexPositionInputs vertexInput = GetVertexPositionInputs(vertexPosition);

                // normalWS and tangentWS already normalize.
                // this is required to avoid skewing the direction during interpolation
                // also required for per-vertex lighting and SH evaluation
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);
                float3 viewDirWS = GetCameraPositionWS() - vertexInput.positionWS;
                half3 vertexLight = VertexLighting(vertexInput.positionWS, normalInput.normalWS);
                half fogFactor = ComputeFogFactor(vertexInput.positionCS.z);

                output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);

                output.dissolveUV = TRANSFORM_TEX(input.texcoord, _DissolveMap);

                // already normalized from normal transform to WS.
                output.normalWS = normalInput.normalWS;
                output.viewDirWS = viewDirWS;
            #ifdef _NORMALMAP
                real sign = input.tangentOS.w * GetOddNegativeScale();
                output.tangentWS = half4(normalInput.tangentWS.xyz, sign);
            #endif

                OUTPUT_LIGHTMAP_UV(input.lightmapUV, unity_LightmapST, output.lightmapUV);
                OUTPUT_SH(output.normalWS.xyz, output.vertexSH);

                output.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

            #if defined(REQUIRES_WORLD_SPACE_POS_INTERPOLATOR)
                output.positionWS = vertexInput.positionWS;
            #endif

            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                output.shadowCoord = GetShadowCoord(vertexInput);
            #endif

                output.positionCS = vertexInput.positionCS;

                return output;
            }

            [maxvertexcount(3)]
            void SublimationDissolveLitGeometry(triangle SublimationDissolveAttributes inputs[3], inout TriangleStream<SublimationDissolveVaryings> outStream) {
                // [unroll]
                // for(int i = 0; i < 3; i++) {
                //     Attributes input = inputs[i];

                //     SublimationDissolveVaryings output = createVaryings(input);

                //     outStream.Append(output);
                // }

                [unroll]
                SublimationDissolveAttributes input0 = inputs[0];
                SublimationDissolveAttributes input1 = inputs[1];
                SublimationDissolveAttributes input2 = inputs[2];
                // [Attributes input3 = inputs[3];

                float3 centerPosition = (input0.positionOS.xyz + input1.positionOS.xyz + input2.positionOS.xyz) * float3(0.5, 0.5, 0.5);

                float dissolve = tex2D(_DissolveMap, float2(0, 0)).r;

                // SublimationDissolveVaryings output0 = createVaryings(input0, float3(0, 0, 0));
                // SublimationDissolveVaryings output1 = createVaryings(input1, float3(0, 0, 0));
                // SublimationDissolveVaryings output2 = createVaryings(input2, float3(0, 0, 0));
                // SublimationDissolveVaryings output3 = createVaryings(input0, ((input1.positionOS.xyz - input0.positionOS.xyz) + (input2.positionOS.xyz - input0.positionOS.xyz)));

                // SublimationDissolveVaryings output0 = createVaryings(input0, centerPosition, float3(-0.05, -0.05, 0), input0.dissolveRate);
                // SublimationDissolveVaryings output1 = createVaryings(input1, centerPosition, float3(-0.05, 0.05, 0), input1.dissolveRate);
                // SublimationDissolveVaryings output2 = createVaryings(input2, centerPosition, float3(0.05, -0.05, 0), input2.dissolveRate);
                // SublimationDissolveVaryings output3 = createVaryings(input0, centerPosition, float3(0.05, 0.05, 0), input0.dissolveRate);

                SublimationDissolveVaryings output0 = createVaryings(input0, input0.positionOS.xyz, float3(0, 0, 0), input0.dissolveRate);
                SublimationDissolveVaryings output1 = createVaryings(input1, input1.positionOS.xyz, float3(0, 0, 0), input1.dissolveRate);
                SublimationDissolveVaryings output2 = createVaryings(input2, input2.positionOS.xyz, float3(0, 0, 0), input2.dissolveRate);
                SublimationDissolveVaryings output3 = createVaryings(input0, input0.positionOS.xyz, float3(0, 0, 0), input0.dissolveRate);

                outStream.Append(output0);
                outStream.Append(output1);
                outStream.Append(output2);
                outStream.Append(output3);

                outStream.RestartStrip();
            }

            // Used in Standard (Physically Based) shader
            half4 SublimationDissolveLitFragment(SublimationDissolveVaryings input) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                SurfaceData surfaceData;
                InitializeStandardLitSurfaceData(input.uv, surfaceData);

                InputData inputData;
                SublimationDissolveInitializeInputData(input, surfaceData.normalTS, inputData);

                float dissolve = tex2D(_DissolveMap, input.dissolveUV).r;
                float effectRate = (dissolve - 1) + lerp(0, 2, _DissolveRate);

                float edgeIn = smoothstep(_DissolveEdgeFadeIn, _DissolveEdgeIn, effectRate);
                float edgeOut = 1. - smoothstep(_DissolveEdgeOut, _DissolveEdgeFadeOut, effectRate);
                float edgeRate = edgeIn * edgeOut;

                // half3 emission = surfaceData.emission + _DissolveEdgeEmissionColor.rgb * edgeRate;
                half3 emission = half3(0, 0, 0);

                half4 color = UniversalFragmentPBR(inputData, surfaceData.albedo, surfaceData.metallic, surfaceData.specular, surfaceData.smoothness, surfaceData.occlusion, emission, surfaceData.alpha);

                color.rgb = MixFog(color.rgb, inputData.fogCoord);
                // color.a = OutputAlpha(color.a * effectRate, _Surface);
                color.a = OutputAlpha(color.a * edgeRate, _Surface);

                color.rgb = float3(input.dissolveRate, input.dissolveRate, input.dissolveRate);

                color.a = 1.;

                if(color.a <= .01) {
                    discard;
                }

                return color;
            }

            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature _ALPHATEST_ON

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

            ZWrite On
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature _ALPHATEST_ON
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"
            ENDHLSL
        }

        // This pass it not used during regular rendering, only for lightmap baking.
        Pass
        {
            Name "Meta"
            Tags{"LightMode" = "Meta"}

            Cull Off

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

            #pragma vertex UniversalVertexMeta
            #pragma fragment UniversalFragmentMeta

            #pragma shader_feature _SPECULAR_SETUP
            #pragma shader_feature _EMISSION
            #pragma shader_feature _METALLICSPECGLOSSMAP
            #pragma shader_feature _ALPHATEST_ON
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            #pragma shader_feature _SPECGLOSSMAP

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitMetaPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "Universal2D"
            Tags{ "LightMode" = "Universal2D" }

            Blend[_SrcBlend][_DstBlend]
            ZWrite[_ZWrite]
            Cull[_Cull]

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature _ALPHATEST_ON
            #pragma shader_feature _ALPHAPREMULTIPLY_ON

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/Utils/Universal2D.hlsl"
            ENDHLSL
        }


    }
    FallBack "Hidden/Universal Render Pipeline/FallbackError"
    // CustomEditor "UnityEditor.Rendering.Universal.ShaderGUI.LitShader"
    CustomEditor "UnityEditor.SublimationDissolveShader"
}

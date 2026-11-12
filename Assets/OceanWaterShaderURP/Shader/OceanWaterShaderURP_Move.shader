Shader "ILranch/OceanWaterShaderURP_move"
{
    Properties
    {
        Water_Body_Color("Water Body Color", Color) = (0, 0, 0, 1)
        Wave_Edge_Color("Wave Edge Color", Color) = (0.04313726, 0.1137255, 0.09411765, 1)
        _Smoothhness("Smoothhness", Range(0, 1)) = 0
        _DepthDistribution("DepthDistribution", Range(0, 1)) = 3
        _DepthStrength("DepthStrength", Range(0, 5)) = 0.5
        _EdgeBlendStrength("EdgeBlendStrength", Range(0, 1)) = 0
        _EdgeBlendDistribution("EdgeBlendDistribution", Range(0, 1)) = 0
        Opague_Level("Opague Level", Range(0, 1)) = 1
        Refraction("Refraction", Range(0.9, 1)) = 0.97
        _Occlusion("Occlusion", Range(0, 1)) = 1
        [ToggleUI]_Xtra_Mode("Xtra Mode", Float) = 0
        [ToggleUI]_Wave_1_Mode_B("Wave 1 Mode B", Float) = 0
        [ToggleUI]_Wave_1_All_Color("Wave 1 All Color", Float) = 0
        Wave_1_Time("Wave 1 Time", Range(0.5, 5)) = 0.5
        Wave_1_Scale("Wave 1 Scale", Range(0.5, 100)) = 1
        Wave_1_Height("Wave 1 Height", Float) = 0.33
        Wave_1_Move_X("Wave 1 Move X", Range(-0.5, 0.5)) = 0.012
        Wave_1_Move_Y("Wave 1 Move Y", Range(-0.5, 0.5)) = 0.012
        _Wave_1_Normal_Strngth("Wave 1 Normal Strngth", Range(0, 0.3)) = 0.04
        Wave_2_Time("Wave 2 Time", Range(0, 2.5)) = 1
        Wave_2_Scale("Wave 2 Scale", Range(0.1, 3)) = 1
        Wave_2_Height("Wave 2 Height", Float) = 0.33
        Wave_2_Horiz_Shake("Wave 2 Horiz Shake", Range(0, 1)) = 0.5
        Wave_2_Horiz_Shake_Scale("Wave 2 Horiz Shake Scale", Range(0, 4)) = 0.5
        Wave_3_Normal_Strngth_A("Wave 3 Normal Strngth A", Range(0, 1)) = 0.4
        Wave_3_Normal_Strngth_B("Wave 3 Normal Strngth B", Range(0, 1)) = 0.4
        Wave_3_Move_X("Wave 3 Move X", Range(-0.5, 0.5)) = -0.005
        Wave_3_Move_Y("Wave 3 Move Y", Range(-0.5, 0.5)) = -0.005
        Wave_3_Scale_A("Wave 3 Scale A", Vector) = (0.2, 0.2, 0, 0)
        Wave_3_Scale_B("Wave 3 Scale B", Vector) = (8, 8, 0, 0)
        [Normal][NoScaleOffset]Wave_3_Texture("Wave 3 Texture", 2D) = "bump" {}
        [ToggleUI]_Wave_4_Enable("Wave 4 Enable", Float) = 0
        _Strength_1("Strength 1", Range(10, 100)) = 100
        _Strength_2("Strength 2", Range(1, 5)) = 2
        [ToggleUI]_Enable_Foam("Enable Foam", Float) = 1
        _Foam_Scale("Foam Scale", Range(1, 5)) = 2
        _FoamDistribution("FoamDistribution", Range(-1, 5)) = 0
        _FoamStrength("FoamStrength", Range(0, 1)) = 1
        _FoamColor("FoamColor", Color) = (0.6705883, 0.6235294, 0.6235294, 0.5176471)
        [NoScaleOffset]_FoamTexture("FoamTexture", 2D) = "white" {}
        _Foam_Bump("Foam Bump", Range(0, 0.1)) = 0
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Off
        Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHAPREMULTIPLY_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 fogFactorAndVertexLight : INTERP7;
             float3 positionWS : INTERP8;
             float3 normalWS : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Wave_1_All_Color;
        float _Strength_2;
        float Wave_1_Scale;
        float Wave_3_Move_X;
        float Wave_1_Move_X;
        float Wave_1_Move_Y;
        float Wave_3_Move_Y;
        float Wave_1_Height;
        float2 Wave_3_Scale_B;
        float Wave_2_Height;
        float Wave_1_Time;
        float Wave_3_Normal_Strngth_A;
        float4 Water_Body_Color;
        float4 Wave_Edge_Color;
        float Refraction;
        float Opague_Level;
        float Wave_2_Scale;
        float Wave_2_Horiz_Shake;
        float Wave_2_Horiz_Shake_Scale;
        float Wave_2_Time;
        float Wave_3_Normal_Strngth_B;
        float _Smoothhness;
        float _DepthStrength;
        float _DepthDistribution;
        float4 Wave_3_Texture_TexelSize;
        float _Occlusion;
        float _Wave_1_Normal_Strngth;
        float _Foam_Scale;
        float _FoamDistribution;
        float _FoamStrength;
        float4 _FoamTexture_TexelSize;
        float4 _FoamColor;
        float _EdgeBlendStrength;
        float _EdgeBlendDistribution;
        float _Enable_Foam;
        float _Xtra_Mode;
        float2 Wave_3_Scale_A;
        float _Wave_1_Mode_B;
        float _Foam_Bump;
        float _Wave_4_Enable;
        float _Strength_1;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Wave_3_Texture);
        SAMPLER(samplerWave_3_Texture);
        TEXTURE2D(_FoamTexture);
        SAMPLER(sampler_FoamTexture);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING) && defined(RAYTRACING_SHADER_GRAPH_DEFAULT)
                    #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            float3 worldDerivativeX = ddx(Position);
            float3 worldDerivativeY = ddy(Position);
        
            float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
            float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
            float d = dot(worldDerivativeX, crossY);
            float sgn = d < 0.0 ? (-1.0f) : 1.0f;
            float surface = sgn / max(0.000000000000001192093f, abs(d));
        
            float dHdx = ddx(In);
            float dHdy = ddy(In);
            float3 surfGrad = surface * (dHdx*crossY + dHdy*crossX);
            Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
            Out = TransformWorldToTangent(Out, TangentMatrix);
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float = Wave_2_Scale;
            float2 _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2 = _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float.xx;
            float _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float = Wave_2_Time;
            float _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float, _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float);
            float2 _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2 = _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float.xx;
            float2 _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2, _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2, _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2);
            float _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float = Wave_2_Horiz_Shake_Scale;
            float _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float, _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float);
            float _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float;
            Unity_Power_float(_GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float, float(1), _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float);
            float3 _Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3 = _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float.xxx;
            float _Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float = Wave_2_Horiz_Shake;
            float _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float;
            Unity_Multiply_float_float(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, -1, _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3 = float3(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, float(0), _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3, _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3, _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3);
            float _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, float(1), _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float);
            float3 _Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3 = _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float.xxx;
            float _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float = Wave_2_Height;
            float3 _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3 = _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float.xxx;
            float3 _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3, _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3, _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3);
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float);
            float3 _Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3 = _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float.xxx;
            float _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float = Wave_1_Height;
            float3 _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3 = _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float.xxx;
            float3 _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3, _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3);
            float3 _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3;
            Unity_Add_float3(_Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3, _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3);
            float3 _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3 = _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3.xxx;
            float3 _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3, _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3);
            float3 _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3);
            float3 _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3, _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3);
            description.Position = _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float _Split_377b3c010ba5423dba14ec331c426c3d_R_1_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[0];
            float _Split_377b3c010ba5423dba14ec331c426c3d_G_2_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[1];
            float _Split_377b3c010ba5423dba14ec331c426c3d_B_3_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[2];
            float _Split_377b3c010ba5423dba14ec331c426c3d_A_4_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[3];
            float4 _Combine_7dfc15beb2a04d4291883bc04854c79e_RGBA_4_Vector4;
            float3 _Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3;
            float2 _Combine_7dfc15beb2a04d4291883bc04854c79e_RG_6_Vector2;
            Unity_Combine_float(_Split_377b3c010ba5423dba14ec331c426c3d_R_1_Float, _Split_377b3c010ba5423dba14ec331c426c3d_G_2_Float, _Split_377b3c010ba5423dba14ec331c426c3d_B_3_Float, float(0), _Combine_7dfc15beb2a04d4291883bc04854c79e_RGBA_4_Vector4, _Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3, _Combine_7dfc15beb2a04d4291883bc04854c79e_RG_6_Vector2);
            float _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, 0.1, _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float);
            float2 _Swizzle_005eadd84e55420d95c2c90dbae55f7c_Out_1_Vector2 = _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float.xx;
            float2 _TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (3, 3), _Swizzle_005eadd84e55420d95c2c90dbae55f7c_Out_1_Vector2, _TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2);
            float _GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2, float(10), _GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float);
            float3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3;
            float3x3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float,float(0.01),_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Position,_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_TangentMatrix, _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3);
            float _Float_20bc6059eb2146249c66329a2b699797_Out_0_Float = float(0.5);
            float3 _Swizzle_76a324a4c91f45a5a7504dad5e2e02de_Out_1_Vector3 = _Float_20bc6059eb2146249c66329a2b699797_Out_0_Float.xxx;
            float3 _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3;
            Unity_Multiply_float3_float3(_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3, _Swizzle_76a324a4c91f45a5a7504dad5e2e02de_Out_1_Vector3, _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3);
            float3 _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3;
            Unity_Add_float3(_Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3, _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3, _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3);
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_R_1_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[0];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_G_2_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[1];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_B_3_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[2];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_A_4_Float = 0;
            float4 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4;
            float3 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGB_5_Vector3;
            float2 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RG_6_Vector2;
            Unity_Combine_float(_Split_7bbe9fedaece4341a083f7f43b6b7d9c_R_1_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_G_2_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_B_3_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_A_4_Float, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGB_5_Vector3, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RG_6_Vector2);
            float3 _SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3;
            Unity_SceneColor_float(_Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4, _SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3);
            float _Property_54712e7ba1864687818d8f787ade3ea7_Out_0_Boolean = _Enable_Foam;
            float4 _Property_890d31ab96654e4bac11c748bf7e4641_Out_0_Vector4 = Water_Body_Color;
            float4 _Property_99e2b40349d44a0d8668aaa14c8b804a_Out_0_Vector4 = Wave_Edge_Color;
            float _Property_1040787057b04f1ea1a2f59828591d48_Out_0_Boolean = _Wave_1_All_Color;
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float;
            float _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float, _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Cells_4_Float);
            float2 _Swizzle_da99028e9d4548e385c610ae7868a193_Out_1_Vector2 = _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float.xx;
            float _RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_da99028e9d4548e385c610ae7868a193_Out_1_Vector2, float(0), float(0.3), _RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float);
            float _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float;
            float _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float, _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Cells_4_Float);
            float2 _Swizzle_2f9c4fb7696e40bb878c9342a7d03e34_Out_1_Vector2 = _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float.xx;
            float _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_2f9c4fb7696e40bb878c9342a7d03e34_Out_1_Vector2, float(0), float(0.3), _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float);
            float _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float;
            Unity_Multiply_float_float(_RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float, _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float, _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float);
            float _Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float, 2, _Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float);
            float _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float;
            Unity_OneMinus_float(_Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float, _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float);
            float _Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float;
            Unity_Multiply_float_float(_Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float, _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float, _Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float);
            float _Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float;
            Unity_Add_float(_Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float, _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float, _Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float);
            float _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float;
            Unity_Multiply_float_float(2, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float);
            float _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float;
            float _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Cells_4_Float);
            float _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float;
            Unity_Multiply_float_float(_Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float);
            float _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float;
            float _Voronoi_035e66672cf64440a56080bd42c7e2c2_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, float(7), _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float, _Voronoi_035e66672cf64440a56080bd42c7e2c2_Cells_4_Float);
            float _Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float;
            Unity_Smoothstep_float(float(0.36), float(0.72), _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float, _Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float);
            float _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float;
            Unity_Multiply_float_float(_Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float, 2, _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float);
            float _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float);
            float _Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float;
            Unity_Branch_float(_Property_1040787057b04f1ea1a2f59828591d48_Out_0_Boolean, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float, _Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float);
            float _SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float);
            float _Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float, _ProjectionParams.z, _Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float);
            float4 _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_R_1_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[0];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_G_2_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[1];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_B_3_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[2];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_A_4_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[3];
            float _Property_5dabeb8853164aaeb4e988181b8b9720_Out_0_Float = _DepthDistribution;
            float _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float;
            Unity_Add_float(_Split_e2f25dd3151246ae92c42ad9f084fb08_A_4_Float, _Property_5dabeb8853164aaeb4e988181b8b9720_Out_0_Float, _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float);
            float _Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float;
            Unity_Subtract_float(_Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float, _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float, _Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float);
            float _Property_508048d246254e00a116b88e267b1bd3_Out_0_Float = _DepthStrength;
            float _Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float, _Property_508048d246254e00a116b88e267b1bd3_Out_0_Float, _Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float);
            float _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float;
            Unity_Clamp_float(_Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float, float(0), float(1), _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float);
            float _Add_99516d93816e4273a3908308f95ba225_Out_2_Float;
            Unity_Add_float(_Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float, _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float, _Add_99516d93816e4273a3908308f95ba225_Out_2_Float);
            float4 _Swizzle_b11ae10f0a10468687eadd49fdddf366_Out_1_Vector4 = _Add_99516d93816e4273a3908308f95ba225_Out_2_Float.xxxx;
            float4 _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4;
            Unity_Lerp_float4(_Property_890d31ab96654e4bac11c748bf7e4641_Out_0_Vector4, _Property_99e2b40349d44a0d8668aaa14c8b804a_Out_0_Vector4, _Swizzle_b11ae10f0a10468687eadd49fdddf366_Out_1_Vector4, _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4);
            UnityTexture2D _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FoamTexture);
            float _Property_8ef00f5e8e19461f886a826695043dff_Out_0_Float = _Foam_Scale;
            float2 _Swizzle_6b00ff458ce142748a4b9e894f8e7bdc_Out_1_Vector2 = _Property_8ef00f5e8e19461f886a826695043dff_Out_0_Float.xx;
            float2 _TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6b00ff458ce142748a4b9e894f8e7bdc_Out_1_Vector2, float2 (0, 0), _TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2);
            float4 _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.tex, _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.samplerstate, _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2) );
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_R_4_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.r;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_G_5_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.g;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_B_6_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.b;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_A_7_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.a;
            float _SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float);
            float _Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float, _ProjectionParams.z, _Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float);
            float4 _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_6ee40854a2c6485fa13841cd79a811a4_R_1_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[0];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_G_2_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[1];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_B_3_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[2];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_A_4_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[3];
            float _Property_59a107015d234919a23075e0493479e7_Out_0_Float = _FoamDistribution;
            float _Add_02ef2739da7b419e99743253dd542709_Out_2_Float;
            Unity_Add_float(_Split_6ee40854a2c6485fa13841cd79a811a4_A_4_Float, _Property_59a107015d234919a23075e0493479e7_Out_0_Float, _Add_02ef2739da7b419e99743253dd542709_Out_2_Float);
            float _Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float;
            Unity_Subtract_float(_Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float, _Add_02ef2739da7b419e99743253dd542709_Out_2_Float, _Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float);
            float _Property_cd578333159d4940b9d2322e37be49e9_Out_0_Float = _FoamStrength;
            float _Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float, _Property_cd578333159d4940b9d2322e37be49e9_Out_0_Float, _Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float);
            float _Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float;
            Unity_Clamp_float(_Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float, float(0), float(1), _Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float);
            float _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float;
            Unity_Smoothstep_float(_Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float, float(2), _SampleTexture2D_eca122bc311046819a95157ab43caa94_A_7_Float, _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float);
            float4 _Swizzle_6ade92d2005e4e7894588a26122a9d4c_Out_1_Vector4 = _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float.xxxx;
            float4 _Property_7d76aa18002a4bb488b56e6e3af24842_Out_0_Vector4 = _FoamColor;
            float4 _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Swizzle_6ade92d2005e4e7894588a26122a9d4c_Out_1_Vector4, _Property_7d76aa18002a4bb488b56e6e3af24842_Out_0_Vector4, _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4);
            float4 _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4, _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4, _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4, _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4);
            float4 _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4;
            Unity_Branch_float4(_Property_54712e7ba1864687818d8f787ade3ea7_Out_0_Boolean, _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4, _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4, _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4);
            float _Split_98cb72d2146c4089be6ecde42edf59df_R_1_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[0];
            float _Split_98cb72d2146c4089be6ecde42edf59df_G_2_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[1];
            float _Split_98cb72d2146c4089be6ecde42edf59df_B_3_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[2];
            float _Split_98cb72d2146c4089be6ecde42edf59df_A_4_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[3];
            float4 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGBA_4_Vector4;
            float3 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3;
            float2 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RG_6_Vector2;
            Unity_Combine_float(_Split_98cb72d2146c4089be6ecde42edf59df_R_1_Float, _Split_98cb72d2146c4089be6ecde42edf59df_G_2_Float, _Split_98cb72d2146c4089be6ecde42edf59df_B_3_Float, float(0), _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGBA_4_Vector4, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RG_6_Vector2);
            float _Property_3f8b7b25769046f6b3af783a32563bb9_Out_0_Float = Refraction;
            float3 _Swizzle_501785d1544c49919e6cc3f890a170ef_Out_1_Vector3 = _Property_3f8b7b25769046f6b3af783a32563bb9_Out_0_Float.xxx;
            float3 _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3;
            Unity_Lerp_float3(_SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3, _Swizzle_501785d1544c49919e6cc3f890a170ef_Out_1_Vector3, _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3);
            float _Property_48fbf2b8adca4702b188572af1893a28_Out_0_Boolean = _Wave_4_Enable;
            float _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float = Wave_2_Scale;
            float2 _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2 = _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float.xx;
            float _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float = Wave_2_Time;
            float _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float, _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float);
            float2 _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2 = _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float.xx;
            float2 _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2, _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2, _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2);
            float _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, float(1), _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float);
            float _Property_55abe08d1d2f4a65848ae264128c3801_Out_0_Float = _Strength_1;
            float3 _NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Out_1_Vector3;
            float3x3 _NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float,_Property_55abe08d1d2f4a65848ae264128c3801_Out_0_Float,_NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Position,_NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_TangentMatrix, _NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Out_1_Vector3);
            UnityTexture2D _Property_251a796ee9834ed88967cecf1c033196_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(Wave_3_Texture);
            float2 _TilingAndOffset_81b08f8fc8e84d378a5c2a5b61cb1285_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.1, 0.1), float2 (0, 0), _TilingAndOffset_81b08f8fc8e84d378a5c2a5b61cb1285_Out_3_Vector2);
            float4 _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_251a796ee9834ed88967cecf1c033196_Out_0_Texture2D.tex, _Property_251a796ee9834ed88967cecf1c033196_Out_0_Texture2D.samplerstate, _Property_251a796ee9834ed88967cecf1c033196_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_81b08f8fc8e84d378a5c2a5b61cb1285_Out_3_Vector2) );
            _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4);
            float _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_R_4_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.r;
            float _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_G_5_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.g;
            float _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_B_6_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.b;
            float _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_A_7_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.a;
            float _Split_bb0caede06ab4e4ea9a9632439c253fe_R_1_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4[0];
            float _Split_bb0caede06ab4e4ea9a9632439c253fe_G_2_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4[1];
            float _Split_bb0caede06ab4e4ea9a9632439c253fe_B_3_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4[2];
            float _Split_bb0caede06ab4e4ea9a9632439c253fe_A_4_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4[3];
            float4 _Combine_d94bba26acb94ababbffe53b9c0a8925_RGBA_4_Vector4;
            float3 _Combine_d94bba26acb94ababbffe53b9c0a8925_RGB_5_Vector3;
            float2 _Combine_d94bba26acb94ababbffe53b9c0a8925_RG_6_Vector2;
            Unity_Combine_float(_Split_bb0caede06ab4e4ea9a9632439c253fe_R_1_Float, _Split_bb0caede06ab4e4ea9a9632439c253fe_G_2_Float, _Split_bb0caede06ab4e4ea9a9632439c253fe_B_3_Float, float(0), _Combine_d94bba26acb94ababbffe53b9c0a8925_RGBA_4_Vector4, _Combine_d94bba26acb94ababbffe53b9c0a8925_RGB_5_Vector3, _Combine_d94bba26acb94ababbffe53b9c0a8925_RG_6_Vector2);
            float _Property_bb64e0b0257f45e1ac71df1267daca90_Out_0_Float = _Strength_2;
            float3 _NormalStrength_9d734aa5a01544a894817da173b381bb_Out_2_Vector3;
            Unity_NormalStrength_float(_Combine_d94bba26acb94ababbffe53b9c0a8925_RGB_5_Vector3, _Property_bb64e0b0257f45e1ac71df1267daca90_Out_0_Float, _NormalStrength_9d734aa5a01544a894817da173b381bb_Out_2_Vector3);
            float3 _NormalBlend_7222208db8414b3fb51c09e1f19d077a_Out_2_Vector3;
            Unity_NormalBlend_float(_NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Out_1_Vector3, _NormalStrength_9d734aa5a01544a894817da173b381bb_Out_2_Vector3, _NormalBlend_7222208db8414b3fb51c09e1f19d077a_Out_2_Vector3);
            float _Property_7b2a8846958d4dc6a963b80d1db01bfb_Out_0_Boolean = _Enable_Foam;
            UnityTexture2D _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(Wave_3_Texture);
            float2 _Property_6561c53a14784ce9acc0e043463d2435_Out_0_Vector2 = Wave_3_Scale_A;
            float2 _Swizzle_22cbb66d4f294b9d893001fca771f096_Out_1_Vector2 = IN.TimeParameters.x.xx;
            float _Property_468ef618d7214e0196b6bc506a6b6bc6_Out_0_Float = Wave_3_Move_X;
            float _Property_5424c06f3fc14de0934f2d8e107644ed_Out_0_Float = Wave_3_Move_Y;
            float2 _Vector2_9b1f214f13714ea28b1ab2978054ab80_Out_0_Vector2 = float2(_Property_468ef618d7214e0196b6bc506a6b6bc6_Out_0_Float, _Property_5424c06f3fc14de0934f2d8e107644ed_Out_0_Float);
            float2 _Multiply_1fc4fddf95854f17a9060cc0e6a895f9_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Swizzle_22cbb66d4f294b9d893001fca771f096_Out_1_Vector2, _Vector2_9b1f214f13714ea28b1ab2978054ab80_Out_0_Vector2, _Multiply_1fc4fddf95854f17a9060cc0e6a895f9_Out_2_Vector2);
            float2 _TilingAndOffset_ff694d3486154f58b6022befe4b24a18_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_6561c53a14784ce9acc0e043463d2435_Out_0_Vector2, _Multiply_1fc4fddf95854f17a9060cc0e6a895f9_Out_2_Vector2, _TilingAndOffset_ff694d3486154f58b6022befe4b24a18_Out_3_Vector2);
            float4 _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.tex, _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.samplerstate, _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_ff694d3486154f58b6022befe4b24a18_Out_3_Vector2) );
            _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4);
            float _SampleTexture2D_bb891f0ff03940289477d416b578bcea_R_4_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.r;
            float _SampleTexture2D_bb891f0ff03940289477d416b578bcea_G_5_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.g;
            float _SampleTexture2D_bb891f0ff03940289477d416b578bcea_B_6_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.b;
            float _SampleTexture2D_bb891f0ff03940289477d416b578bcea_A_7_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.a;
            float _Split_9a6a750c5fef4abbb883d76f368bd54c_R_1_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4[0];
            float _Split_9a6a750c5fef4abbb883d76f368bd54c_G_2_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4[1];
            float _Split_9a6a750c5fef4abbb883d76f368bd54c_B_3_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4[2];
            float _Split_9a6a750c5fef4abbb883d76f368bd54c_A_4_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4[3];
            float4 _Combine_3c796c43f0d5465ab9d205a60e164663_RGBA_4_Vector4;
            float3 _Combine_3c796c43f0d5465ab9d205a60e164663_RGB_5_Vector3;
            float2 _Combine_3c796c43f0d5465ab9d205a60e164663_RG_6_Vector2;
            Unity_Combine_float(_Split_9a6a750c5fef4abbb883d76f368bd54c_R_1_Float, _Split_9a6a750c5fef4abbb883d76f368bd54c_G_2_Float, _Split_9a6a750c5fef4abbb883d76f368bd54c_B_3_Float, float(0), _Combine_3c796c43f0d5465ab9d205a60e164663_RGBA_4_Vector4, _Combine_3c796c43f0d5465ab9d205a60e164663_RGB_5_Vector3, _Combine_3c796c43f0d5465ab9d205a60e164663_RG_6_Vector2);
            float _Property_d971805948fe40dab752904eac98bc44_Out_0_Float = Wave_3_Normal_Strngth_A;
            float3 _NormalStrength_ae1821be07c24d7e953fe71dd3ec09a8_Out_2_Vector3;
            Unity_NormalStrength_float(_Combine_3c796c43f0d5465ab9d205a60e164663_RGB_5_Vector3, _Property_d971805948fe40dab752904eac98bc44_Out_0_Float, _NormalStrength_ae1821be07c24d7e953fe71dd3ec09a8_Out_2_Vector3);
            float _Property_6fa6713d63344f1285e9053f7b7eca77_Out_0_Boolean = _Wave_1_Mode_B;
            float _Branch_68b0d88eed094e79831e2f33ce768e7f_Out_3_Float;
            Unity_Branch_float(_Property_6fa6713d63344f1285e9053f7b7eca77_Out_0_Boolean, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Branch_68b0d88eed094e79831e2f33ce768e7f_Out_3_Float);
            float _Property_b9c1231a6e1748bc9463d7f9d6ed7acd_Out_0_Float = _Wave_1_Normal_Strngth;
            float3 _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Out_1_Vector3;
            float3x3 _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_Branch_68b0d88eed094e79831e2f33ce768e7f_Out_3_Float,_Property_b9c1231a6e1748bc9463d7f9d6ed7acd_Out_0_Float,_NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Position,_NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_TangentMatrix, _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Out_1_Vector3);
            float3 _NormalBlend_05be32b2e9e84d39b2fd63c277f1dd45_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_NormalStrength_ae1821be07c24d7e953fe71dd3ec09a8_Out_2_Vector3, _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Out_1_Vector3, _NormalBlend_05be32b2e9e84d39b2fd63c277f1dd45_Out_2_Vector3);
            float2 _Property_584e161a7bf8452ca1679a85ece5f585_Out_0_Vector2 = Wave_3_Scale_B;
            float2 _TilingAndOffset_4d30c97ad09c4247b9b380eeb3d57770_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_584e161a7bf8452ca1679a85ece5f585_Out_0_Vector2, _Multiply_1fc4fddf95854f17a9060cc0e6a895f9_Out_2_Vector2, _TilingAndOffset_4d30c97ad09c4247b9b380eeb3d57770_Out_3_Vector2);
            float4 _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.tex, _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.samplerstate, _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_4d30c97ad09c4247b9b380eeb3d57770_Out_3_Vector2) );
            _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4);
            float _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_R_4_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.r;
            float _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_G_5_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.g;
            float _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_B_6_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.b;
            float _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_A_7_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.a;
            float _Split_950a6f18fcb5455088d454048cc68286_R_1_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4[0];
            float _Split_950a6f18fcb5455088d454048cc68286_G_2_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4[1];
            float _Split_950a6f18fcb5455088d454048cc68286_B_3_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4[2];
            float _Split_950a6f18fcb5455088d454048cc68286_A_4_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4[3];
            float4 _Combine_147d91df3731440fbc595dae6b92ea8f_RGBA_4_Vector4;
            float3 _Combine_147d91df3731440fbc595dae6b92ea8f_RGB_5_Vector3;
            float2 _Combine_147d91df3731440fbc595dae6b92ea8f_RG_6_Vector2;
            Unity_Combine_float(_Split_950a6f18fcb5455088d454048cc68286_R_1_Float, _Split_950a6f18fcb5455088d454048cc68286_G_2_Float, _Split_950a6f18fcb5455088d454048cc68286_B_3_Float, float(0), _Combine_147d91df3731440fbc595dae6b92ea8f_RGBA_4_Vector4, _Combine_147d91df3731440fbc595dae6b92ea8f_RGB_5_Vector3, _Combine_147d91df3731440fbc595dae6b92ea8f_RG_6_Vector2);
            float _Property_a6fe24d6da5a49c08ea29fc6654f237b_Out_0_Float = Wave_3_Normal_Strngth_B;
            float3 _NormalStrength_e61bff34334c418dbea0ac5f87379778_Out_2_Vector3;
            Unity_NormalStrength_float(_Combine_147d91df3731440fbc595dae6b92ea8f_RGB_5_Vector3, _Property_a6fe24d6da5a49c08ea29fc6654f237b_Out_0_Float, _NormalStrength_e61bff34334c418dbea0ac5f87379778_Out_2_Vector3);
            float3 _NormalBlend_347331c888ee45408d802d055807bc0c_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_NormalBlend_05be32b2e9e84d39b2fd63c277f1dd45_Out_2_Vector3, _NormalStrength_e61bff34334c418dbea0ac5f87379778_Out_2_Vector3, _NormalBlend_347331c888ee45408d802d055807bc0c_Out_2_Vector3);
            float _Swizzle_9cfe0c38bd7d4e28a3fc415fbdfcc079_Out_1_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.x;
            float _Property_3e5a034e2ea84afe9cc3a0556f9bddea_Out_0_Float = _Foam_Bump;
            float3 _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Out_1_Vector3;
            float3x3 _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_Swizzle_9cfe0c38bd7d4e28a3fc415fbdfcc079_Out_1_Float,_Property_3e5a034e2ea84afe9cc3a0556f9bddea_Out_0_Float,_NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Position,_NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_TangentMatrix, _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Out_1_Vector3);
            float3 _NormalBlend_9942f62d334b4af0876b315da5d6c220_Out_2_Vector3;
            Unity_NormalBlend_float(_NormalBlend_347331c888ee45408d802d055807bc0c_Out_2_Vector3, _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Out_1_Vector3, _NormalBlend_9942f62d334b4af0876b315da5d6c220_Out_2_Vector3);
            float3 _Branch_bd708651ebb84694bc607081a117ee63_Out_3_Vector3;
            Unity_Branch_float3(_Property_7b2a8846958d4dc6a963b80d1db01bfb_Out_0_Boolean, _NormalBlend_9942f62d334b4af0876b315da5d6c220_Out_2_Vector3, _NormalBlend_347331c888ee45408d802d055807bc0c_Out_2_Vector3, _Branch_bd708651ebb84694bc607081a117ee63_Out_3_Vector3);
            float3 _NormalBlend_cf74fa346c234f03a46cd4c912d1ba8e_Out_2_Vector3;
            Unity_NormalBlend_float(_NormalBlend_7222208db8414b3fb51c09e1f19d077a_Out_2_Vector3, _Branch_bd708651ebb84694bc607081a117ee63_Out_3_Vector3, _NormalBlend_cf74fa346c234f03a46cd4c912d1ba8e_Out_2_Vector3);
            float3 _Branch_14aa568c81d043f8bc67520f1cb50a5f_Out_3_Vector3;
            Unity_Branch_float3(_Property_48fbf2b8adca4702b188572af1893a28_Out_0_Boolean, _NormalBlend_cf74fa346c234f03a46cd4c912d1ba8e_Out_2_Vector3, _Branch_bd708651ebb84694bc607081a117ee63_Out_3_Vector3, _Branch_14aa568c81d043f8bc67520f1cb50a5f_Out_3_Vector3);
            float _Property_b5743c1318574098bc379d8e063d661c_Out_0_Boolean = _Xtra_Mode;
            float _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float);
            float _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float, _ProjectionParams.z, _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float);
            float4 _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_f4c2a8f4b03347289c6dc876561794f6_R_1_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[0];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_G_2_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[1];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_B_3_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[2];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[3];
            float _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float = _EdgeBlendDistribution;
            float _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float;
            Unity_Add_float(_Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float, _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float);
            float _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float;
            Unity_Subtract_float(_Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float, _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float);
            float _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float = _EdgeBlendStrength;
            float _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float, _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float, _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float);
            float _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float;
            Unity_Clamp_float(_Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float, float(0), float(1), _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float);
            float _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float;
            Unity_Multiply_float_float(2, _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float, _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float);
            float _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float = Opague_Level;
            float _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float, _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float, _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float);
            float _OneMinus_bfd22d71fe7a49ab9eddf7269db69b53_Out_1_Float;
            Unity_OneMinus_float(_Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float, _OneMinus_bfd22d71fe7a49ab9eddf7269db69b53_Out_1_Float);
            float _Multiply_b1b93d827a79478baf2ca283be70cb48_Out_2_Float;
            Unity_Multiply_float_float(20, _OneMinus_bfd22d71fe7a49ab9eddf7269db69b53_Out_1_Float, _Multiply_b1b93d827a79478baf2ca283be70cb48_Out_2_Float);
            float _Branch_8e9f27e0d51c46b891649c1418bea967_Out_3_Float;
            Unity_Branch_float(_Property_b5743c1318574098bc379d8e063d661c_Out_0_Boolean, _Multiply_b1b93d827a79478baf2ca283be70cb48_Out_2_Float, float(0), _Branch_8e9f27e0d51c46b891649c1418bea967_Out_3_Float);
            float _Property_973f9808d0104cde96073bc31dd90147_Out_0_Float = _Smoothhness;
            float _Property_bf530ba2433c4bb0b8cc50b92d7e8ce9_Out_0_Float = _Occlusion;
            surface.BaseColor = _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3;
            surface.NormalTS = _Branch_14aa568c81d043f8bc67520f1cb50a5f_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Branch_8e9f27e0d51c46b891649c1418bea967_Out_3_Float;
            surface.Smoothness = _Property_973f9808d0104cde96073bc31dd90147_Out_0_Float;
            surface.Occlusion = _Property_bf530ba2433c4bb0b8cc50b92d7e8ce9_Out_0_Float;
            surface.Alpha = _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Off
        Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHAPREMULTIPLY_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 fogFactorAndVertexLight : INTERP7;
             float3 positionWS : INTERP8;
             float3 normalWS : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Wave_1_All_Color;
        float _Strength_2;
        float Wave_1_Scale;
        float Wave_3_Move_X;
        float Wave_1_Move_X;
        float Wave_1_Move_Y;
        float Wave_3_Move_Y;
        float Wave_1_Height;
        float2 Wave_3_Scale_B;
        float Wave_2_Height;
        float Wave_1_Time;
        float Wave_3_Normal_Strngth_A;
        float4 Water_Body_Color;
        float4 Wave_Edge_Color;
        float Refraction;
        float Opague_Level;
        float Wave_2_Scale;
        float Wave_2_Horiz_Shake;
        float Wave_2_Horiz_Shake_Scale;
        float Wave_2_Time;
        float Wave_3_Normal_Strngth_B;
        float _Smoothhness;
        float _DepthStrength;
        float _DepthDistribution;
        float4 Wave_3_Texture_TexelSize;
        float _Occlusion;
        float _Wave_1_Normal_Strngth;
        float _Foam_Scale;
        float _FoamDistribution;
        float _FoamStrength;
        float4 _FoamTexture_TexelSize;
        float4 _FoamColor;
        float _EdgeBlendStrength;
        float _EdgeBlendDistribution;
        float _Enable_Foam;
        float _Xtra_Mode;
        float2 Wave_3_Scale_A;
        float _Wave_1_Mode_B;
        float _Foam_Bump;
        float _Wave_4_Enable;
        float _Strength_1;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Wave_3_Texture);
        SAMPLER(samplerWave_3_Texture);
        TEXTURE2D(_FoamTexture);
        SAMPLER(sampler_FoamTexture);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING) && defined(RAYTRACING_SHADER_GRAPH_DEFAULT)
                    #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            float3 worldDerivativeX = ddx(Position);
            float3 worldDerivativeY = ddy(Position);
        
            float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
            float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
            float d = dot(worldDerivativeX, crossY);
            float sgn = d < 0.0 ? (-1.0f) : 1.0f;
            float surface = sgn / max(0.000000000000001192093f, abs(d));
        
            float dHdx = ddx(In);
            float dHdy = ddy(In);
            float3 surfGrad = surface * (dHdx*crossY + dHdy*crossX);
            Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
            Out = TransformWorldToTangent(Out, TangentMatrix);
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float = Wave_2_Scale;
            float2 _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2 = _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float.xx;
            float _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float = Wave_2_Time;
            float _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float, _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float);
            float2 _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2 = _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float.xx;
            float2 _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2, _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2, _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2);
            float _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float = Wave_2_Horiz_Shake_Scale;
            float _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float, _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float);
            float _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float;
            Unity_Power_float(_GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float, float(1), _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float);
            float3 _Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3 = _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float.xxx;
            float _Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float = Wave_2_Horiz_Shake;
            float _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float;
            Unity_Multiply_float_float(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, -1, _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3 = float3(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, float(0), _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3, _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3, _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3);
            float _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, float(1), _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float);
            float3 _Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3 = _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float.xxx;
            float _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float = Wave_2_Height;
            float3 _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3 = _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float.xxx;
            float3 _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3, _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3, _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3);
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float);
            float3 _Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3 = _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float.xxx;
            float _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float = Wave_1_Height;
            float3 _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3 = _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float.xxx;
            float3 _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3, _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3);
            float3 _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3;
            Unity_Add_float3(_Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3, _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3);
            float3 _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3 = _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3.xxx;
            float3 _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3, _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3);
            float3 _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3);
            float3 _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3, _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3);
            description.Position = _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float _Split_377b3c010ba5423dba14ec331c426c3d_R_1_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[0];
            float _Split_377b3c010ba5423dba14ec331c426c3d_G_2_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[1];
            float _Split_377b3c010ba5423dba14ec331c426c3d_B_3_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[2];
            float _Split_377b3c010ba5423dba14ec331c426c3d_A_4_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[3];
            float4 _Combine_7dfc15beb2a04d4291883bc04854c79e_RGBA_4_Vector4;
            float3 _Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3;
            float2 _Combine_7dfc15beb2a04d4291883bc04854c79e_RG_6_Vector2;
            Unity_Combine_float(_Split_377b3c010ba5423dba14ec331c426c3d_R_1_Float, _Split_377b3c010ba5423dba14ec331c426c3d_G_2_Float, _Split_377b3c010ba5423dba14ec331c426c3d_B_3_Float, float(0), _Combine_7dfc15beb2a04d4291883bc04854c79e_RGBA_4_Vector4, _Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3, _Combine_7dfc15beb2a04d4291883bc04854c79e_RG_6_Vector2);
            float _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, 0.1, _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float);
            float2 _Swizzle_005eadd84e55420d95c2c90dbae55f7c_Out_1_Vector2 = _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float.xx;
            float2 _TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (3, 3), _Swizzle_005eadd84e55420d95c2c90dbae55f7c_Out_1_Vector2, _TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2);
            float _GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2, float(10), _GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float);
            float3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3;
            float3x3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float,float(0.01),_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Position,_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_TangentMatrix, _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3);
            float _Float_20bc6059eb2146249c66329a2b699797_Out_0_Float = float(0.5);
            float3 _Swizzle_76a324a4c91f45a5a7504dad5e2e02de_Out_1_Vector3 = _Float_20bc6059eb2146249c66329a2b699797_Out_0_Float.xxx;
            float3 _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3;
            Unity_Multiply_float3_float3(_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3, _Swizzle_76a324a4c91f45a5a7504dad5e2e02de_Out_1_Vector3, _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3);
            float3 _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3;
            Unity_Add_float3(_Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3, _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3, _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3);
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_R_1_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[0];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_G_2_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[1];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_B_3_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[2];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_A_4_Float = 0;
            float4 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4;
            float3 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGB_5_Vector3;
            float2 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RG_6_Vector2;
            Unity_Combine_float(_Split_7bbe9fedaece4341a083f7f43b6b7d9c_R_1_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_G_2_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_B_3_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_A_4_Float, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGB_5_Vector3, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RG_6_Vector2);
            float3 _SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3;
            Unity_SceneColor_float(_Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4, _SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3);
            float _Property_54712e7ba1864687818d8f787ade3ea7_Out_0_Boolean = _Enable_Foam;
            float4 _Property_890d31ab96654e4bac11c748bf7e4641_Out_0_Vector4 = Water_Body_Color;
            float4 _Property_99e2b40349d44a0d8668aaa14c8b804a_Out_0_Vector4 = Wave_Edge_Color;
            float _Property_1040787057b04f1ea1a2f59828591d48_Out_0_Boolean = _Wave_1_All_Color;
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float;
            float _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float, _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Cells_4_Float);
            float2 _Swizzle_da99028e9d4548e385c610ae7868a193_Out_1_Vector2 = _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float.xx;
            float _RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_da99028e9d4548e385c610ae7868a193_Out_1_Vector2, float(0), float(0.3), _RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float);
            float _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float;
            float _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float, _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Cells_4_Float);
            float2 _Swizzle_2f9c4fb7696e40bb878c9342a7d03e34_Out_1_Vector2 = _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float.xx;
            float _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_2f9c4fb7696e40bb878c9342a7d03e34_Out_1_Vector2, float(0), float(0.3), _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float);
            float _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float;
            Unity_Multiply_float_float(_RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float, _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float, _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float);
            float _Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float, 2, _Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float);
            float _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float;
            Unity_OneMinus_float(_Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float, _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float);
            float _Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float;
            Unity_Multiply_float_float(_Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float, _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float, _Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float);
            float _Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float;
            Unity_Add_float(_Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float, _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float, _Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float);
            float _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float;
            Unity_Multiply_float_float(2, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float);
            float _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float;
            float _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Cells_4_Float);
            float _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float;
            Unity_Multiply_float_float(_Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float);
            float _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float;
            float _Voronoi_035e66672cf64440a56080bd42c7e2c2_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, float(7), _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float, _Voronoi_035e66672cf64440a56080bd42c7e2c2_Cells_4_Float);
            float _Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float;
            Unity_Smoothstep_float(float(0.36), float(0.72), _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float, _Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float);
            float _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float;
            Unity_Multiply_float_float(_Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float, 2, _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float);
            float _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float);
            float _Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float;
            Unity_Branch_float(_Property_1040787057b04f1ea1a2f59828591d48_Out_0_Boolean, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float, _Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float);
            float _SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float);
            float _Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float, _ProjectionParams.z, _Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float);
            float4 _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_R_1_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[0];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_G_2_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[1];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_B_3_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[2];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_A_4_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[3];
            float _Property_5dabeb8853164aaeb4e988181b8b9720_Out_0_Float = _DepthDistribution;
            float _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float;
            Unity_Add_float(_Split_e2f25dd3151246ae92c42ad9f084fb08_A_4_Float, _Property_5dabeb8853164aaeb4e988181b8b9720_Out_0_Float, _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float);
            float _Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float;
            Unity_Subtract_float(_Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float, _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float, _Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float);
            float _Property_508048d246254e00a116b88e267b1bd3_Out_0_Float = _DepthStrength;
            float _Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float, _Property_508048d246254e00a116b88e267b1bd3_Out_0_Float, _Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float);
            float _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float;
            Unity_Clamp_float(_Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float, float(0), float(1), _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float);
            float _Add_99516d93816e4273a3908308f95ba225_Out_2_Float;
            Unity_Add_float(_Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float, _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float, _Add_99516d93816e4273a3908308f95ba225_Out_2_Float);
            float4 _Swizzle_b11ae10f0a10468687eadd49fdddf366_Out_1_Vector4 = _Add_99516d93816e4273a3908308f95ba225_Out_2_Float.xxxx;
            float4 _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4;
            Unity_Lerp_float4(_Property_890d31ab96654e4bac11c748bf7e4641_Out_0_Vector4, _Property_99e2b40349d44a0d8668aaa14c8b804a_Out_0_Vector4, _Swizzle_b11ae10f0a10468687eadd49fdddf366_Out_1_Vector4, _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4);
            UnityTexture2D _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FoamTexture);
            float _Property_8ef00f5e8e19461f886a826695043dff_Out_0_Float = _Foam_Scale;
            float2 _Swizzle_6b00ff458ce142748a4b9e894f8e7bdc_Out_1_Vector2 = _Property_8ef00f5e8e19461f886a826695043dff_Out_0_Float.xx;
            float2 _TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6b00ff458ce142748a4b9e894f8e7bdc_Out_1_Vector2, float2 (0, 0), _TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2);
            float4 _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.tex, _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.samplerstate, _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2) );
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_R_4_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.r;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_G_5_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.g;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_B_6_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.b;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_A_7_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.a;
            float _SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float);
            float _Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float, _ProjectionParams.z, _Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float);
            float4 _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_6ee40854a2c6485fa13841cd79a811a4_R_1_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[0];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_G_2_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[1];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_B_3_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[2];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_A_4_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[3];
            float _Property_59a107015d234919a23075e0493479e7_Out_0_Float = _FoamDistribution;
            float _Add_02ef2739da7b419e99743253dd542709_Out_2_Float;
            Unity_Add_float(_Split_6ee40854a2c6485fa13841cd79a811a4_A_4_Float, _Property_59a107015d234919a23075e0493479e7_Out_0_Float, _Add_02ef2739da7b419e99743253dd542709_Out_2_Float);
            float _Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float;
            Unity_Subtract_float(_Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float, _Add_02ef2739da7b419e99743253dd542709_Out_2_Float, _Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float);
            float _Property_cd578333159d4940b9d2322e37be49e9_Out_0_Float = _FoamStrength;
            float _Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float, _Property_cd578333159d4940b9d2322e37be49e9_Out_0_Float, _Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float);
            float _Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float;
            Unity_Clamp_float(_Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float, float(0), float(1), _Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float);
            float _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float;
            Unity_Smoothstep_float(_Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float, float(2), _SampleTexture2D_eca122bc311046819a95157ab43caa94_A_7_Float, _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float);
            float4 _Swizzle_6ade92d2005e4e7894588a26122a9d4c_Out_1_Vector4 = _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float.xxxx;
            float4 _Property_7d76aa18002a4bb488b56e6e3af24842_Out_0_Vector4 = _FoamColor;
            float4 _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Swizzle_6ade92d2005e4e7894588a26122a9d4c_Out_1_Vector4, _Property_7d76aa18002a4bb488b56e6e3af24842_Out_0_Vector4, _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4);
            float4 _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4, _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4, _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4, _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4);
            float4 _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4;
            Unity_Branch_float4(_Property_54712e7ba1864687818d8f787ade3ea7_Out_0_Boolean, _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4, _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4, _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4);
            float _Split_98cb72d2146c4089be6ecde42edf59df_R_1_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[0];
            float _Split_98cb72d2146c4089be6ecde42edf59df_G_2_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[1];
            float _Split_98cb72d2146c4089be6ecde42edf59df_B_3_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[2];
            float _Split_98cb72d2146c4089be6ecde42edf59df_A_4_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[3];
            float4 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGBA_4_Vector4;
            float3 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3;
            float2 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RG_6_Vector2;
            Unity_Combine_float(_Split_98cb72d2146c4089be6ecde42edf59df_R_1_Float, _Split_98cb72d2146c4089be6ecde42edf59df_G_2_Float, _Split_98cb72d2146c4089be6ecde42edf59df_B_3_Float, float(0), _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGBA_4_Vector4, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RG_6_Vector2);
            float _Property_3f8b7b25769046f6b3af783a32563bb9_Out_0_Float = Refraction;
            float3 _Swizzle_501785d1544c49919e6cc3f890a170ef_Out_1_Vector3 = _Property_3f8b7b25769046f6b3af783a32563bb9_Out_0_Float.xxx;
            float3 _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3;
            Unity_Lerp_float3(_SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3, _Swizzle_501785d1544c49919e6cc3f890a170ef_Out_1_Vector3, _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3);
            float _Property_48fbf2b8adca4702b188572af1893a28_Out_0_Boolean = _Wave_4_Enable;
            float _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float = Wave_2_Scale;
            float2 _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2 = _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float.xx;
            float _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float = Wave_2_Time;
            float _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float, _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float);
            float2 _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2 = _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float.xx;
            float2 _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2, _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2, _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2);
            float _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, float(1), _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float);
            float _Property_55abe08d1d2f4a65848ae264128c3801_Out_0_Float = _Strength_1;
            float3 _NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Out_1_Vector3;
            float3x3 _NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float,_Property_55abe08d1d2f4a65848ae264128c3801_Out_0_Float,_NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Position,_NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_TangentMatrix, _NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Out_1_Vector3);
            UnityTexture2D _Property_251a796ee9834ed88967cecf1c033196_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(Wave_3_Texture);
            float2 _TilingAndOffset_81b08f8fc8e84d378a5c2a5b61cb1285_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.1, 0.1), float2 (0, 0), _TilingAndOffset_81b08f8fc8e84d378a5c2a5b61cb1285_Out_3_Vector2);
            float4 _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_251a796ee9834ed88967cecf1c033196_Out_0_Texture2D.tex, _Property_251a796ee9834ed88967cecf1c033196_Out_0_Texture2D.samplerstate, _Property_251a796ee9834ed88967cecf1c033196_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_81b08f8fc8e84d378a5c2a5b61cb1285_Out_3_Vector2) );
            _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4);
            float _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_R_4_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.r;
            float _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_G_5_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.g;
            float _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_B_6_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.b;
            float _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_A_7_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.a;
            float _Split_bb0caede06ab4e4ea9a9632439c253fe_R_1_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4[0];
            float _Split_bb0caede06ab4e4ea9a9632439c253fe_G_2_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4[1];
            float _Split_bb0caede06ab4e4ea9a9632439c253fe_B_3_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4[2];
            float _Split_bb0caede06ab4e4ea9a9632439c253fe_A_4_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4[3];
            float4 _Combine_d94bba26acb94ababbffe53b9c0a8925_RGBA_4_Vector4;
            float3 _Combine_d94bba26acb94ababbffe53b9c0a8925_RGB_5_Vector3;
            float2 _Combine_d94bba26acb94ababbffe53b9c0a8925_RG_6_Vector2;
            Unity_Combine_float(_Split_bb0caede06ab4e4ea9a9632439c253fe_R_1_Float, _Split_bb0caede06ab4e4ea9a9632439c253fe_G_2_Float, _Split_bb0caede06ab4e4ea9a9632439c253fe_B_3_Float, float(0), _Combine_d94bba26acb94ababbffe53b9c0a8925_RGBA_4_Vector4, _Combine_d94bba26acb94ababbffe53b9c0a8925_RGB_5_Vector3, _Combine_d94bba26acb94ababbffe53b9c0a8925_RG_6_Vector2);
            float _Property_bb64e0b0257f45e1ac71df1267daca90_Out_0_Float = _Strength_2;
            float3 _NormalStrength_9d734aa5a01544a894817da173b381bb_Out_2_Vector3;
            Unity_NormalStrength_float(_Combine_d94bba26acb94ababbffe53b9c0a8925_RGB_5_Vector3, _Property_bb64e0b0257f45e1ac71df1267daca90_Out_0_Float, _NormalStrength_9d734aa5a01544a894817da173b381bb_Out_2_Vector3);
            float3 _NormalBlend_7222208db8414b3fb51c09e1f19d077a_Out_2_Vector3;
            Unity_NormalBlend_float(_NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Out_1_Vector3, _NormalStrength_9d734aa5a01544a894817da173b381bb_Out_2_Vector3, _NormalBlend_7222208db8414b3fb51c09e1f19d077a_Out_2_Vector3);
            float _Property_7b2a8846958d4dc6a963b80d1db01bfb_Out_0_Boolean = _Enable_Foam;
            UnityTexture2D _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(Wave_3_Texture);
            float2 _Property_6561c53a14784ce9acc0e043463d2435_Out_0_Vector2 = Wave_3_Scale_A;
            float2 _Swizzle_22cbb66d4f294b9d893001fca771f096_Out_1_Vector2 = IN.TimeParameters.x.xx;
            float _Property_468ef618d7214e0196b6bc506a6b6bc6_Out_0_Float = Wave_3_Move_X;
            float _Property_5424c06f3fc14de0934f2d8e107644ed_Out_0_Float = Wave_3_Move_Y;
            float2 _Vector2_9b1f214f13714ea28b1ab2978054ab80_Out_0_Vector2 = float2(_Property_468ef618d7214e0196b6bc506a6b6bc6_Out_0_Float, _Property_5424c06f3fc14de0934f2d8e107644ed_Out_0_Float);
            float2 _Multiply_1fc4fddf95854f17a9060cc0e6a895f9_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Swizzle_22cbb66d4f294b9d893001fca771f096_Out_1_Vector2, _Vector2_9b1f214f13714ea28b1ab2978054ab80_Out_0_Vector2, _Multiply_1fc4fddf95854f17a9060cc0e6a895f9_Out_2_Vector2);
            float2 _TilingAndOffset_ff694d3486154f58b6022befe4b24a18_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_6561c53a14784ce9acc0e043463d2435_Out_0_Vector2, _Multiply_1fc4fddf95854f17a9060cc0e6a895f9_Out_2_Vector2, _TilingAndOffset_ff694d3486154f58b6022befe4b24a18_Out_3_Vector2);
            float4 _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.tex, _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.samplerstate, _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_ff694d3486154f58b6022befe4b24a18_Out_3_Vector2) );
            _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4);
            float _SampleTexture2D_bb891f0ff03940289477d416b578bcea_R_4_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.r;
            float _SampleTexture2D_bb891f0ff03940289477d416b578bcea_G_5_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.g;
            float _SampleTexture2D_bb891f0ff03940289477d416b578bcea_B_6_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.b;
            float _SampleTexture2D_bb891f0ff03940289477d416b578bcea_A_7_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.a;
            float _Split_9a6a750c5fef4abbb883d76f368bd54c_R_1_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4[0];
            float _Split_9a6a750c5fef4abbb883d76f368bd54c_G_2_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4[1];
            float _Split_9a6a750c5fef4abbb883d76f368bd54c_B_3_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4[2];
            float _Split_9a6a750c5fef4abbb883d76f368bd54c_A_4_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4[3];
            float4 _Combine_3c796c43f0d5465ab9d205a60e164663_RGBA_4_Vector4;
            float3 _Combine_3c796c43f0d5465ab9d205a60e164663_RGB_5_Vector3;
            float2 _Combine_3c796c43f0d5465ab9d205a60e164663_RG_6_Vector2;
            Unity_Combine_float(_Split_9a6a750c5fef4abbb883d76f368bd54c_R_1_Float, _Split_9a6a750c5fef4abbb883d76f368bd54c_G_2_Float, _Split_9a6a750c5fef4abbb883d76f368bd54c_B_3_Float, float(0), _Combine_3c796c43f0d5465ab9d205a60e164663_RGBA_4_Vector4, _Combine_3c796c43f0d5465ab9d205a60e164663_RGB_5_Vector3, _Combine_3c796c43f0d5465ab9d205a60e164663_RG_6_Vector2);
            float _Property_d971805948fe40dab752904eac98bc44_Out_0_Float = Wave_3_Normal_Strngth_A;
            float3 _NormalStrength_ae1821be07c24d7e953fe71dd3ec09a8_Out_2_Vector3;
            Unity_NormalStrength_float(_Combine_3c796c43f0d5465ab9d205a60e164663_RGB_5_Vector3, _Property_d971805948fe40dab752904eac98bc44_Out_0_Float, _NormalStrength_ae1821be07c24d7e953fe71dd3ec09a8_Out_2_Vector3);
            float _Property_6fa6713d63344f1285e9053f7b7eca77_Out_0_Boolean = _Wave_1_Mode_B;
            float _Branch_68b0d88eed094e79831e2f33ce768e7f_Out_3_Float;
            Unity_Branch_float(_Property_6fa6713d63344f1285e9053f7b7eca77_Out_0_Boolean, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Branch_68b0d88eed094e79831e2f33ce768e7f_Out_3_Float);
            float _Property_b9c1231a6e1748bc9463d7f9d6ed7acd_Out_0_Float = _Wave_1_Normal_Strngth;
            float3 _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Out_1_Vector3;
            float3x3 _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_Branch_68b0d88eed094e79831e2f33ce768e7f_Out_3_Float,_Property_b9c1231a6e1748bc9463d7f9d6ed7acd_Out_0_Float,_NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Position,_NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_TangentMatrix, _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Out_1_Vector3);
            float3 _NormalBlend_05be32b2e9e84d39b2fd63c277f1dd45_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_NormalStrength_ae1821be07c24d7e953fe71dd3ec09a8_Out_2_Vector3, _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Out_1_Vector3, _NormalBlend_05be32b2e9e84d39b2fd63c277f1dd45_Out_2_Vector3);
            float2 _Property_584e161a7bf8452ca1679a85ece5f585_Out_0_Vector2 = Wave_3_Scale_B;
            float2 _TilingAndOffset_4d30c97ad09c4247b9b380eeb3d57770_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_584e161a7bf8452ca1679a85ece5f585_Out_0_Vector2, _Multiply_1fc4fddf95854f17a9060cc0e6a895f9_Out_2_Vector2, _TilingAndOffset_4d30c97ad09c4247b9b380eeb3d57770_Out_3_Vector2);
            float4 _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.tex, _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.samplerstate, _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_4d30c97ad09c4247b9b380eeb3d57770_Out_3_Vector2) );
            _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4);
            float _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_R_4_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.r;
            float _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_G_5_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.g;
            float _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_B_6_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.b;
            float _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_A_7_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.a;
            float _Split_950a6f18fcb5455088d454048cc68286_R_1_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4[0];
            float _Split_950a6f18fcb5455088d454048cc68286_G_2_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4[1];
            float _Split_950a6f18fcb5455088d454048cc68286_B_3_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4[2];
            float _Split_950a6f18fcb5455088d454048cc68286_A_4_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4[3];
            float4 _Combine_147d91df3731440fbc595dae6b92ea8f_RGBA_4_Vector4;
            float3 _Combine_147d91df3731440fbc595dae6b92ea8f_RGB_5_Vector3;
            float2 _Combine_147d91df3731440fbc595dae6b92ea8f_RG_6_Vector2;
            Unity_Combine_float(_Split_950a6f18fcb5455088d454048cc68286_R_1_Float, _Split_950a6f18fcb5455088d454048cc68286_G_2_Float, _Split_950a6f18fcb5455088d454048cc68286_B_3_Float, float(0), _Combine_147d91df3731440fbc595dae6b92ea8f_RGBA_4_Vector4, _Combine_147d91df3731440fbc595dae6b92ea8f_RGB_5_Vector3, _Combine_147d91df3731440fbc595dae6b92ea8f_RG_6_Vector2);
            float _Property_a6fe24d6da5a49c08ea29fc6654f237b_Out_0_Float = Wave_3_Normal_Strngth_B;
            float3 _NormalStrength_e61bff34334c418dbea0ac5f87379778_Out_2_Vector3;
            Unity_NormalStrength_float(_Combine_147d91df3731440fbc595dae6b92ea8f_RGB_5_Vector3, _Property_a6fe24d6da5a49c08ea29fc6654f237b_Out_0_Float, _NormalStrength_e61bff34334c418dbea0ac5f87379778_Out_2_Vector3);
            float3 _NormalBlend_347331c888ee45408d802d055807bc0c_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_NormalBlend_05be32b2e9e84d39b2fd63c277f1dd45_Out_2_Vector3, _NormalStrength_e61bff34334c418dbea0ac5f87379778_Out_2_Vector3, _NormalBlend_347331c888ee45408d802d055807bc0c_Out_2_Vector3);
            float _Swizzle_9cfe0c38bd7d4e28a3fc415fbdfcc079_Out_1_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.x;
            float _Property_3e5a034e2ea84afe9cc3a0556f9bddea_Out_0_Float = _Foam_Bump;
            float3 _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Out_1_Vector3;
            float3x3 _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_Swizzle_9cfe0c38bd7d4e28a3fc415fbdfcc079_Out_1_Float,_Property_3e5a034e2ea84afe9cc3a0556f9bddea_Out_0_Float,_NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Position,_NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_TangentMatrix, _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Out_1_Vector3);
            float3 _NormalBlend_9942f62d334b4af0876b315da5d6c220_Out_2_Vector3;
            Unity_NormalBlend_float(_NormalBlend_347331c888ee45408d802d055807bc0c_Out_2_Vector3, _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Out_1_Vector3, _NormalBlend_9942f62d334b4af0876b315da5d6c220_Out_2_Vector3);
            float3 _Branch_bd708651ebb84694bc607081a117ee63_Out_3_Vector3;
            Unity_Branch_float3(_Property_7b2a8846958d4dc6a963b80d1db01bfb_Out_0_Boolean, _NormalBlend_9942f62d334b4af0876b315da5d6c220_Out_2_Vector3, _NormalBlend_347331c888ee45408d802d055807bc0c_Out_2_Vector3, _Branch_bd708651ebb84694bc607081a117ee63_Out_3_Vector3);
            float3 _NormalBlend_cf74fa346c234f03a46cd4c912d1ba8e_Out_2_Vector3;
            Unity_NormalBlend_float(_NormalBlend_7222208db8414b3fb51c09e1f19d077a_Out_2_Vector3, _Branch_bd708651ebb84694bc607081a117ee63_Out_3_Vector3, _NormalBlend_cf74fa346c234f03a46cd4c912d1ba8e_Out_2_Vector3);
            float3 _Branch_14aa568c81d043f8bc67520f1cb50a5f_Out_3_Vector3;
            Unity_Branch_float3(_Property_48fbf2b8adca4702b188572af1893a28_Out_0_Boolean, _NormalBlend_cf74fa346c234f03a46cd4c912d1ba8e_Out_2_Vector3, _Branch_bd708651ebb84694bc607081a117ee63_Out_3_Vector3, _Branch_14aa568c81d043f8bc67520f1cb50a5f_Out_3_Vector3);
            float _Property_b5743c1318574098bc379d8e063d661c_Out_0_Boolean = _Xtra_Mode;
            float _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float);
            float _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float, _ProjectionParams.z, _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float);
            float4 _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_f4c2a8f4b03347289c6dc876561794f6_R_1_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[0];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_G_2_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[1];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_B_3_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[2];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[3];
            float _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float = _EdgeBlendDistribution;
            float _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float;
            Unity_Add_float(_Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float, _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float);
            float _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float;
            Unity_Subtract_float(_Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float, _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float);
            float _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float = _EdgeBlendStrength;
            float _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float, _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float, _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float);
            float _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float;
            Unity_Clamp_float(_Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float, float(0), float(1), _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float);
            float _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float;
            Unity_Multiply_float_float(2, _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float, _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float);
            float _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float = Opague_Level;
            float _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float, _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float, _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float);
            float _OneMinus_bfd22d71fe7a49ab9eddf7269db69b53_Out_1_Float;
            Unity_OneMinus_float(_Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float, _OneMinus_bfd22d71fe7a49ab9eddf7269db69b53_Out_1_Float);
            float _Multiply_b1b93d827a79478baf2ca283be70cb48_Out_2_Float;
            Unity_Multiply_float_float(20, _OneMinus_bfd22d71fe7a49ab9eddf7269db69b53_Out_1_Float, _Multiply_b1b93d827a79478baf2ca283be70cb48_Out_2_Float);
            float _Branch_8e9f27e0d51c46b891649c1418bea967_Out_3_Float;
            Unity_Branch_float(_Property_b5743c1318574098bc379d8e063d661c_Out_0_Boolean, _Multiply_b1b93d827a79478baf2ca283be70cb48_Out_2_Float, float(0), _Branch_8e9f27e0d51c46b891649c1418bea967_Out_3_Float);
            float _Property_973f9808d0104cde96073bc31dd90147_Out_0_Float = _Smoothhness;
            float _Property_bf530ba2433c4bb0b8cc50b92d7e8ce9_Out_0_Float = _Occlusion;
            surface.BaseColor = _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3;
            surface.NormalTS = _Branch_14aa568c81d043f8bc67520f1cb50a5f_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Branch_8e9f27e0d51c46b891649c1418bea967_Out_3_Float;
            surface.Smoothness = _Property_973f9808d0104cde96073bc31dd90147_Out_0_Float;
            surface.Occlusion = _Property_bf530ba2433c4bb0b8cc50b92d7e8ce9_Out_0_Float;
            surface.Alpha = _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
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
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Wave_1_All_Color;
        float _Strength_2;
        float Wave_1_Scale;
        float Wave_3_Move_X;
        float Wave_1_Move_X;
        float Wave_1_Move_Y;
        float Wave_3_Move_Y;
        float Wave_1_Height;
        float2 Wave_3_Scale_B;
        float Wave_2_Height;
        float Wave_1_Time;
        float Wave_3_Normal_Strngth_A;
        float4 Water_Body_Color;
        float4 Wave_Edge_Color;
        float Refraction;
        float Opague_Level;
        float Wave_2_Scale;
        float Wave_2_Horiz_Shake;
        float Wave_2_Horiz_Shake_Scale;
        float Wave_2_Time;
        float Wave_3_Normal_Strngth_B;
        float _Smoothhness;
        float _DepthStrength;
        float _DepthDistribution;
        float4 Wave_3_Texture_TexelSize;
        float _Occlusion;
        float _Wave_1_Normal_Strngth;
        float _Foam_Scale;
        float _FoamDistribution;
        float _FoamStrength;
        float4 _FoamTexture_TexelSize;
        float4 _FoamColor;
        float _EdgeBlendStrength;
        float _EdgeBlendDistribution;
        float _Enable_Foam;
        float _Xtra_Mode;
        float2 Wave_3_Scale_A;
        float _Wave_1_Mode_B;
        float _Foam_Bump;
        float _Wave_4_Enable;
        float _Strength_1;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Wave_3_Texture);
        SAMPLER(samplerWave_3_Texture);
        TEXTURE2D(_FoamTexture);
        SAMPLER(sampler_FoamTexture);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float = Wave_2_Scale;
            float2 _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2 = _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float.xx;
            float _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float = Wave_2_Time;
            float _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float, _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float);
            float2 _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2 = _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float.xx;
            float2 _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2, _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2, _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2);
            float _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float = Wave_2_Horiz_Shake_Scale;
            float _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float, _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float);
            float _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float;
            Unity_Power_float(_GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float, float(1), _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float);
            float3 _Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3 = _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float.xxx;
            float _Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float = Wave_2_Horiz_Shake;
            float _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float;
            Unity_Multiply_float_float(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, -1, _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3 = float3(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, float(0), _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3, _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3, _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3);
            float _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, float(1), _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float);
            float3 _Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3 = _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float.xxx;
            float _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float = Wave_2_Height;
            float3 _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3 = _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float.xxx;
            float3 _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3, _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3, _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3);
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float);
            float3 _Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3 = _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float.xxx;
            float _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float = Wave_1_Height;
            float3 _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3 = _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float.xxx;
            float3 _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3, _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3);
            float3 _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3;
            Unity_Add_float3(_Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3, _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3);
            float3 _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3 = _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3.xxx;
            float3 _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3, _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3);
            float3 _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3);
            float3 _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3, _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3);
            description.Position = _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float);
            float _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float, _ProjectionParams.z, _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float);
            float4 _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_f4c2a8f4b03347289c6dc876561794f6_R_1_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[0];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_G_2_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[1];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_B_3_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[2];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[3];
            float _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float = _EdgeBlendDistribution;
            float _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float;
            Unity_Add_float(_Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float, _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float);
            float _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float;
            Unity_Subtract_float(_Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float, _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float);
            float _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float = _EdgeBlendStrength;
            float _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float, _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float, _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float);
            float _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float;
            Unity_Clamp_float(_Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float, float(0), float(1), _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float);
            float _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float;
            Unity_Multiply_float_float(2, _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float, _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float);
            float _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float = Opague_Level;
            float _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float, _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float, _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float);
            surface.Alpha = _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Wave_1_All_Color;
        float _Strength_2;
        float Wave_1_Scale;
        float Wave_3_Move_X;
        float Wave_1_Move_X;
        float Wave_1_Move_Y;
        float Wave_3_Move_Y;
        float Wave_1_Height;
        float2 Wave_3_Scale_B;
        float Wave_2_Height;
        float Wave_1_Time;
        float Wave_3_Normal_Strngth_A;
        float4 Water_Body_Color;
        float4 Wave_Edge_Color;
        float Refraction;
        float Opague_Level;
        float Wave_2_Scale;
        float Wave_2_Horiz_Shake;
        float Wave_2_Horiz_Shake_Scale;
        float Wave_2_Time;
        float Wave_3_Normal_Strngth_B;
        float _Smoothhness;
        float _DepthStrength;
        float _DepthDistribution;
        float4 Wave_3_Texture_TexelSize;
        float _Occlusion;
        float _Wave_1_Normal_Strngth;
        float _Foam_Scale;
        float _FoamDistribution;
        float _FoamStrength;
        float4 _FoamTexture_TexelSize;
        float4 _FoamColor;
        float _EdgeBlendStrength;
        float _EdgeBlendDistribution;
        float _Enable_Foam;
        float _Xtra_Mode;
        float2 Wave_3_Scale_A;
        float _Wave_1_Mode_B;
        float _Foam_Bump;
        float _Wave_4_Enable;
        float _Strength_1;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Wave_3_Texture);
        SAMPLER(samplerWave_3_Texture);
        TEXTURE2D(_FoamTexture);
        SAMPLER(sampler_FoamTexture);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float = Wave_2_Scale;
            float2 _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2 = _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float.xx;
            float _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float = Wave_2_Time;
            float _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float, _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float);
            float2 _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2 = _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float.xx;
            float2 _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2, _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2, _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2);
            float _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float = Wave_2_Horiz_Shake_Scale;
            float _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float, _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float);
            float _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float;
            Unity_Power_float(_GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float, float(1), _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float);
            float3 _Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3 = _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float.xxx;
            float _Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float = Wave_2_Horiz_Shake;
            float _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float;
            Unity_Multiply_float_float(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, -1, _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3 = float3(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, float(0), _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3, _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3, _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3);
            float _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, float(1), _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float);
            float3 _Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3 = _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float.xxx;
            float _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float = Wave_2_Height;
            float3 _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3 = _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float.xxx;
            float3 _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3, _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3, _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3);
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float);
            float3 _Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3 = _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float.xxx;
            float _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float = Wave_1_Height;
            float3 _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3 = _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float.xxx;
            float3 _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3, _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3);
            float3 _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3;
            Unity_Add_float3(_Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3, _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3);
            float3 _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3 = _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3.xxx;
            float3 _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3, _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3);
            float3 _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3);
            float3 _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3, _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3);
            description.Position = _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float);
            float _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float, _ProjectionParams.z, _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float);
            float4 _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_f4c2a8f4b03347289c6dc876561794f6_R_1_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[0];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_G_2_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[1];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_B_3_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[2];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[3];
            float _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float = _EdgeBlendDistribution;
            float _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float;
            Unity_Add_float(_Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float, _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float);
            float _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float;
            Unity_Subtract_float(_Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float, _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float);
            float _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float = _EdgeBlendStrength;
            float _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float, _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float, _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float);
            float _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float;
            Unity_Clamp_float(_Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float, float(0), float(1), _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float);
            float _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float;
            Unity_Multiply_float_float(2, _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float, _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float);
            float _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float = Opague_Level;
            float _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float, _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float, _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float);
            surface.Alpha = _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float3 positionWS : INTERP2;
             float3 normalWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Wave_1_All_Color;
        float _Strength_2;
        float Wave_1_Scale;
        float Wave_3_Move_X;
        float Wave_1_Move_X;
        float Wave_1_Move_Y;
        float Wave_3_Move_Y;
        float Wave_1_Height;
        float2 Wave_3_Scale_B;
        float Wave_2_Height;
        float Wave_1_Time;
        float Wave_3_Normal_Strngth_A;
        float4 Water_Body_Color;
        float4 Wave_Edge_Color;
        float Refraction;
        float Opague_Level;
        float Wave_2_Scale;
        float Wave_2_Horiz_Shake;
        float Wave_2_Horiz_Shake_Scale;
        float Wave_2_Time;
        float Wave_3_Normal_Strngth_B;
        float _Smoothhness;
        float _DepthStrength;
        float _DepthDistribution;
        float4 Wave_3_Texture_TexelSize;
        float _Occlusion;
        float _Wave_1_Normal_Strngth;
        float _Foam_Scale;
        float _FoamDistribution;
        float _FoamStrength;
        float4 _FoamTexture_TexelSize;
        float4 _FoamColor;
        float _EdgeBlendStrength;
        float _EdgeBlendDistribution;
        float _Enable_Foam;
        float _Xtra_Mode;
        float2 Wave_3_Scale_A;
        float _Wave_1_Mode_B;
        float _Foam_Bump;
        float _Wave_4_Enable;
        float _Strength_1;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Wave_3_Texture);
        SAMPLER(samplerWave_3_Texture);
        TEXTURE2D(_FoamTexture);
        SAMPLER(sampler_FoamTexture);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING) && defined(RAYTRACING_SHADER_GRAPH_DEFAULT)
                    #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            float3 worldDerivativeX = ddx(Position);
            float3 worldDerivativeY = ddy(Position);
        
            float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
            float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
            float d = dot(worldDerivativeX, crossY);
            float sgn = d < 0.0 ? (-1.0f) : 1.0f;
            float surface = sgn / max(0.000000000000001192093f, abs(d));
        
            float dHdx = ddx(In);
            float dHdy = ddy(In);
            float3 surfGrad = surface * (dHdx*crossY + dHdy*crossX);
            Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
            Out = TransformWorldToTangent(Out, TangentMatrix);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float = Wave_2_Scale;
            float2 _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2 = _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float.xx;
            float _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float = Wave_2_Time;
            float _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float, _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float);
            float2 _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2 = _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float.xx;
            float2 _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2, _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2, _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2);
            float _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float = Wave_2_Horiz_Shake_Scale;
            float _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float, _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float);
            float _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float;
            Unity_Power_float(_GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float, float(1), _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float);
            float3 _Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3 = _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float.xxx;
            float _Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float = Wave_2_Horiz_Shake;
            float _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float;
            Unity_Multiply_float_float(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, -1, _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3 = float3(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, float(0), _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3, _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3, _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3);
            float _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, float(1), _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float);
            float3 _Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3 = _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float.xxx;
            float _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float = Wave_2_Height;
            float3 _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3 = _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float.xxx;
            float3 _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3, _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3, _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3);
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float);
            float3 _Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3 = _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float.xxx;
            float _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float = Wave_1_Height;
            float3 _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3 = _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float.xxx;
            float3 _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3, _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3);
            float3 _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3;
            Unity_Add_float3(_Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3, _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3);
            float3 _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3 = _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3.xxx;
            float3 _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3, _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3);
            float3 _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3);
            float3 _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3, _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3);
            description.Position = _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_48fbf2b8adca4702b188572af1893a28_Out_0_Boolean = _Wave_4_Enable;
            float _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float = Wave_2_Scale;
            float2 _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2 = _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float.xx;
            float _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float = Wave_2_Time;
            float _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float, _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float);
            float2 _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2 = _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float.xx;
            float2 _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2, _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2, _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2);
            float _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, float(1), _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float);
            float _Property_55abe08d1d2f4a65848ae264128c3801_Out_0_Float = _Strength_1;
            float3 _NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Out_1_Vector3;
            float3x3 _NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float,_Property_55abe08d1d2f4a65848ae264128c3801_Out_0_Float,_NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Position,_NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_TangentMatrix, _NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Out_1_Vector3);
            UnityTexture2D _Property_251a796ee9834ed88967cecf1c033196_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(Wave_3_Texture);
            float2 _TilingAndOffset_81b08f8fc8e84d378a5c2a5b61cb1285_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (0.1, 0.1), float2 (0, 0), _TilingAndOffset_81b08f8fc8e84d378a5c2a5b61cb1285_Out_3_Vector2);
            float4 _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_251a796ee9834ed88967cecf1c033196_Out_0_Texture2D.tex, _Property_251a796ee9834ed88967cecf1c033196_Out_0_Texture2D.samplerstate, _Property_251a796ee9834ed88967cecf1c033196_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_81b08f8fc8e84d378a5c2a5b61cb1285_Out_3_Vector2) );
            _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4);
            float _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_R_4_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.r;
            float _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_G_5_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.g;
            float _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_B_6_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.b;
            float _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_A_7_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4.a;
            float _Split_bb0caede06ab4e4ea9a9632439c253fe_R_1_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4[0];
            float _Split_bb0caede06ab4e4ea9a9632439c253fe_G_2_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4[1];
            float _Split_bb0caede06ab4e4ea9a9632439c253fe_B_3_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4[2];
            float _Split_bb0caede06ab4e4ea9a9632439c253fe_A_4_Float = _SampleTexture2D_de60c32d0eb740e282a5d5851792dbf7_RGBA_0_Vector4[3];
            float4 _Combine_d94bba26acb94ababbffe53b9c0a8925_RGBA_4_Vector4;
            float3 _Combine_d94bba26acb94ababbffe53b9c0a8925_RGB_5_Vector3;
            float2 _Combine_d94bba26acb94ababbffe53b9c0a8925_RG_6_Vector2;
            Unity_Combine_float(_Split_bb0caede06ab4e4ea9a9632439c253fe_R_1_Float, _Split_bb0caede06ab4e4ea9a9632439c253fe_G_2_Float, _Split_bb0caede06ab4e4ea9a9632439c253fe_B_3_Float, float(0), _Combine_d94bba26acb94ababbffe53b9c0a8925_RGBA_4_Vector4, _Combine_d94bba26acb94ababbffe53b9c0a8925_RGB_5_Vector3, _Combine_d94bba26acb94ababbffe53b9c0a8925_RG_6_Vector2);
            float _Property_bb64e0b0257f45e1ac71df1267daca90_Out_0_Float = _Strength_2;
            float3 _NormalStrength_9d734aa5a01544a894817da173b381bb_Out_2_Vector3;
            Unity_NormalStrength_float(_Combine_d94bba26acb94ababbffe53b9c0a8925_RGB_5_Vector3, _Property_bb64e0b0257f45e1ac71df1267daca90_Out_0_Float, _NormalStrength_9d734aa5a01544a894817da173b381bb_Out_2_Vector3);
            float3 _NormalBlend_7222208db8414b3fb51c09e1f19d077a_Out_2_Vector3;
            Unity_NormalBlend_float(_NormalFromHeight_b8cd9f92820545668595e7cfe19881dc_Out_1_Vector3, _NormalStrength_9d734aa5a01544a894817da173b381bb_Out_2_Vector3, _NormalBlend_7222208db8414b3fb51c09e1f19d077a_Out_2_Vector3);
            float _Property_7b2a8846958d4dc6a963b80d1db01bfb_Out_0_Boolean = _Enable_Foam;
            UnityTexture2D _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(Wave_3_Texture);
            float2 _Property_6561c53a14784ce9acc0e043463d2435_Out_0_Vector2 = Wave_3_Scale_A;
            float2 _Swizzle_22cbb66d4f294b9d893001fca771f096_Out_1_Vector2 = IN.TimeParameters.x.xx;
            float _Property_468ef618d7214e0196b6bc506a6b6bc6_Out_0_Float = Wave_3_Move_X;
            float _Property_5424c06f3fc14de0934f2d8e107644ed_Out_0_Float = Wave_3_Move_Y;
            float2 _Vector2_9b1f214f13714ea28b1ab2978054ab80_Out_0_Vector2 = float2(_Property_468ef618d7214e0196b6bc506a6b6bc6_Out_0_Float, _Property_5424c06f3fc14de0934f2d8e107644ed_Out_0_Float);
            float2 _Multiply_1fc4fddf95854f17a9060cc0e6a895f9_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Swizzle_22cbb66d4f294b9d893001fca771f096_Out_1_Vector2, _Vector2_9b1f214f13714ea28b1ab2978054ab80_Out_0_Vector2, _Multiply_1fc4fddf95854f17a9060cc0e6a895f9_Out_2_Vector2);
            float2 _TilingAndOffset_ff694d3486154f58b6022befe4b24a18_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_6561c53a14784ce9acc0e043463d2435_Out_0_Vector2, _Multiply_1fc4fddf95854f17a9060cc0e6a895f9_Out_2_Vector2, _TilingAndOffset_ff694d3486154f58b6022befe4b24a18_Out_3_Vector2);
            float4 _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.tex, _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.samplerstate, _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_ff694d3486154f58b6022befe4b24a18_Out_3_Vector2) );
            _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4);
            float _SampleTexture2D_bb891f0ff03940289477d416b578bcea_R_4_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.r;
            float _SampleTexture2D_bb891f0ff03940289477d416b578bcea_G_5_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.g;
            float _SampleTexture2D_bb891f0ff03940289477d416b578bcea_B_6_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.b;
            float _SampleTexture2D_bb891f0ff03940289477d416b578bcea_A_7_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4.a;
            float _Split_9a6a750c5fef4abbb883d76f368bd54c_R_1_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4[0];
            float _Split_9a6a750c5fef4abbb883d76f368bd54c_G_2_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4[1];
            float _Split_9a6a750c5fef4abbb883d76f368bd54c_B_3_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4[2];
            float _Split_9a6a750c5fef4abbb883d76f368bd54c_A_4_Float = _SampleTexture2D_bb891f0ff03940289477d416b578bcea_RGBA_0_Vector4[3];
            float4 _Combine_3c796c43f0d5465ab9d205a60e164663_RGBA_4_Vector4;
            float3 _Combine_3c796c43f0d5465ab9d205a60e164663_RGB_5_Vector3;
            float2 _Combine_3c796c43f0d5465ab9d205a60e164663_RG_6_Vector2;
            Unity_Combine_float(_Split_9a6a750c5fef4abbb883d76f368bd54c_R_1_Float, _Split_9a6a750c5fef4abbb883d76f368bd54c_G_2_Float, _Split_9a6a750c5fef4abbb883d76f368bd54c_B_3_Float, float(0), _Combine_3c796c43f0d5465ab9d205a60e164663_RGBA_4_Vector4, _Combine_3c796c43f0d5465ab9d205a60e164663_RGB_5_Vector3, _Combine_3c796c43f0d5465ab9d205a60e164663_RG_6_Vector2);
            float _Property_d971805948fe40dab752904eac98bc44_Out_0_Float = Wave_3_Normal_Strngth_A;
            float3 _NormalStrength_ae1821be07c24d7e953fe71dd3ec09a8_Out_2_Vector3;
            Unity_NormalStrength_float(_Combine_3c796c43f0d5465ab9d205a60e164663_RGB_5_Vector3, _Property_d971805948fe40dab752904eac98bc44_Out_0_Float, _NormalStrength_ae1821be07c24d7e953fe71dd3ec09a8_Out_2_Vector3);
            float _Property_6fa6713d63344f1285e9053f7b7eca77_Out_0_Boolean = _Wave_1_Mode_B;
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float;
            float _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float, _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Cells_4_Float);
            float2 _Swizzle_da99028e9d4548e385c610ae7868a193_Out_1_Vector2 = _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float.xx;
            float _RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_da99028e9d4548e385c610ae7868a193_Out_1_Vector2, float(0), float(0.3), _RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float);
            float _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float;
            float _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float, _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Cells_4_Float);
            float2 _Swizzle_2f9c4fb7696e40bb878c9342a7d03e34_Out_1_Vector2 = _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float.xx;
            float _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_2f9c4fb7696e40bb878c9342a7d03e34_Out_1_Vector2, float(0), float(0.3), _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float);
            float _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float;
            Unity_Multiply_float_float(_RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float, _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float, _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float);
            float _Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float, 2, _Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float);
            float _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float;
            Unity_OneMinus_float(_Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float, _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float);
            float _Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float;
            Unity_Multiply_float_float(_Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float, _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float, _Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float);
            float _Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float;
            Unity_Add_float(_Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float, _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float, _Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float);
            float _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float;
            Unity_Multiply_float_float(2, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float);
            float _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float;
            float _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Cells_4_Float);
            float _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float;
            Unity_Multiply_float_float(_Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float);
            float _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float;
            float _Voronoi_035e66672cf64440a56080bd42c7e2c2_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, float(7), _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float, _Voronoi_035e66672cf64440a56080bd42c7e2c2_Cells_4_Float);
            float _Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float;
            Unity_Smoothstep_float(float(0.36), float(0.72), _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float, _Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float);
            float _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float;
            Unity_Multiply_float_float(_Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float, 2, _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float);
            float _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float);
            float _Branch_68b0d88eed094e79831e2f33ce768e7f_Out_3_Float;
            Unity_Branch_float(_Property_6fa6713d63344f1285e9053f7b7eca77_Out_0_Boolean, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Branch_68b0d88eed094e79831e2f33ce768e7f_Out_3_Float);
            float _Property_b9c1231a6e1748bc9463d7f9d6ed7acd_Out_0_Float = _Wave_1_Normal_Strngth;
            float3 _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Out_1_Vector3;
            float3x3 _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_Branch_68b0d88eed094e79831e2f33ce768e7f_Out_3_Float,_Property_b9c1231a6e1748bc9463d7f9d6ed7acd_Out_0_Float,_NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Position,_NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_TangentMatrix, _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Out_1_Vector3);
            float3 _NormalBlend_05be32b2e9e84d39b2fd63c277f1dd45_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_NormalStrength_ae1821be07c24d7e953fe71dd3ec09a8_Out_2_Vector3, _NormalFromHeight_067660ab4bb14cbc818e08e0ed998b8f_Out_1_Vector3, _NormalBlend_05be32b2e9e84d39b2fd63c277f1dd45_Out_2_Vector3);
            float2 _Property_584e161a7bf8452ca1679a85ece5f585_Out_0_Vector2 = Wave_3_Scale_B;
            float2 _TilingAndOffset_4d30c97ad09c4247b9b380eeb3d57770_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_584e161a7bf8452ca1679a85ece5f585_Out_0_Vector2, _Multiply_1fc4fddf95854f17a9060cc0e6a895f9_Out_2_Vector2, _TilingAndOffset_4d30c97ad09c4247b9b380eeb3d57770_Out_3_Vector2);
            float4 _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.tex, _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.samplerstate, _Property_650e67dbdc5944c59b9e40beeeb58156_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_4d30c97ad09c4247b9b380eeb3d57770_Out_3_Vector2) );
            _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4);
            float _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_R_4_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.r;
            float _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_G_5_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.g;
            float _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_B_6_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.b;
            float _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_A_7_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4.a;
            float _Split_950a6f18fcb5455088d454048cc68286_R_1_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4[0];
            float _Split_950a6f18fcb5455088d454048cc68286_G_2_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4[1];
            float _Split_950a6f18fcb5455088d454048cc68286_B_3_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4[2];
            float _Split_950a6f18fcb5455088d454048cc68286_A_4_Float = _SampleTexture2D_9fba653e656244c487cc63a442b3f56d_RGBA_0_Vector4[3];
            float4 _Combine_147d91df3731440fbc595dae6b92ea8f_RGBA_4_Vector4;
            float3 _Combine_147d91df3731440fbc595dae6b92ea8f_RGB_5_Vector3;
            float2 _Combine_147d91df3731440fbc595dae6b92ea8f_RG_6_Vector2;
            Unity_Combine_float(_Split_950a6f18fcb5455088d454048cc68286_R_1_Float, _Split_950a6f18fcb5455088d454048cc68286_G_2_Float, _Split_950a6f18fcb5455088d454048cc68286_B_3_Float, float(0), _Combine_147d91df3731440fbc595dae6b92ea8f_RGBA_4_Vector4, _Combine_147d91df3731440fbc595dae6b92ea8f_RGB_5_Vector3, _Combine_147d91df3731440fbc595dae6b92ea8f_RG_6_Vector2);
            float _Property_a6fe24d6da5a49c08ea29fc6654f237b_Out_0_Float = Wave_3_Normal_Strngth_B;
            float3 _NormalStrength_e61bff34334c418dbea0ac5f87379778_Out_2_Vector3;
            Unity_NormalStrength_float(_Combine_147d91df3731440fbc595dae6b92ea8f_RGB_5_Vector3, _Property_a6fe24d6da5a49c08ea29fc6654f237b_Out_0_Float, _NormalStrength_e61bff34334c418dbea0ac5f87379778_Out_2_Vector3);
            float3 _NormalBlend_347331c888ee45408d802d055807bc0c_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_NormalBlend_05be32b2e9e84d39b2fd63c277f1dd45_Out_2_Vector3, _NormalStrength_e61bff34334c418dbea0ac5f87379778_Out_2_Vector3, _NormalBlend_347331c888ee45408d802d055807bc0c_Out_2_Vector3);
            UnityTexture2D _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FoamTexture);
            float _Property_8ef00f5e8e19461f886a826695043dff_Out_0_Float = _Foam_Scale;
            float2 _Swizzle_6b00ff458ce142748a4b9e894f8e7bdc_Out_1_Vector2 = _Property_8ef00f5e8e19461f886a826695043dff_Out_0_Float.xx;
            float2 _TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6b00ff458ce142748a4b9e894f8e7bdc_Out_1_Vector2, float2 (0, 0), _TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2);
            float4 _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.tex, _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.samplerstate, _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2) );
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_R_4_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.r;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_G_5_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.g;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_B_6_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.b;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_A_7_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.a;
            float _Swizzle_9cfe0c38bd7d4e28a3fc415fbdfcc079_Out_1_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.x;
            float _Property_3e5a034e2ea84afe9cc3a0556f9bddea_Out_0_Float = _Foam_Bump;
            float3 _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Out_1_Vector3;
            float3x3 _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_Swizzle_9cfe0c38bd7d4e28a3fc415fbdfcc079_Out_1_Float,_Property_3e5a034e2ea84afe9cc3a0556f9bddea_Out_0_Float,_NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Position,_NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_TangentMatrix, _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Out_1_Vector3);
            float3 _NormalBlend_9942f62d334b4af0876b315da5d6c220_Out_2_Vector3;
            Unity_NormalBlend_float(_NormalBlend_347331c888ee45408d802d055807bc0c_Out_2_Vector3, _NormalFromHeight_5dd0b17b381645558f9ff45ab861e9d4_Out_1_Vector3, _NormalBlend_9942f62d334b4af0876b315da5d6c220_Out_2_Vector3);
            float3 _Branch_bd708651ebb84694bc607081a117ee63_Out_3_Vector3;
            Unity_Branch_float3(_Property_7b2a8846958d4dc6a963b80d1db01bfb_Out_0_Boolean, _NormalBlend_9942f62d334b4af0876b315da5d6c220_Out_2_Vector3, _NormalBlend_347331c888ee45408d802d055807bc0c_Out_2_Vector3, _Branch_bd708651ebb84694bc607081a117ee63_Out_3_Vector3);
            float3 _NormalBlend_cf74fa346c234f03a46cd4c912d1ba8e_Out_2_Vector3;
            Unity_NormalBlend_float(_NormalBlend_7222208db8414b3fb51c09e1f19d077a_Out_2_Vector3, _Branch_bd708651ebb84694bc607081a117ee63_Out_3_Vector3, _NormalBlend_cf74fa346c234f03a46cd4c912d1ba8e_Out_2_Vector3);
            float3 _Branch_14aa568c81d043f8bc67520f1cb50a5f_Out_3_Vector3;
            Unity_Branch_float3(_Property_48fbf2b8adca4702b188572af1893a28_Out_0_Boolean, _NormalBlend_cf74fa346c234f03a46cd4c912d1ba8e_Out_2_Vector3, _Branch_bd708651ebb84694bc607081a117ee63_Out_3_Vector3, _Branch_14aa568c81d043f8bc67520f1cb50a5f_Out_3_Vector3);
            float _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float);
            float _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float, _ProjectionParams.z, _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float);
            float4 _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_f4c2a8f4b03347289c6dc876561794f6_R_1_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[0];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_G_2_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[1];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_B_3_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[2];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[3];
            float _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float = _EdgeBlendDistribution;
            float _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float;
            Unity_Add_float(_Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float, _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float);
            float _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float;
            Unity_Subtract_float(_Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float, _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float);
            float _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float = _EdgeBlendStrength;
            float _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float, _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float, _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float);
            float _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float;
            Unity_Clamp_float(_Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float, float(0), float(1), _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float);
            float _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float;
            Unity_Multiply_float_float(2, _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float, _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float);
            float _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float = Opague_Level;
            float _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float, _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float, _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float);
            surface.NormalTS = _Branch_14aa568c81d043f8bc67520f1cb50a5f_Out_3_Vector3;
            surface.Alpha = _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
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
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_INSTANCEID
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float4 texCoord1 : INTERP2;
             float4 texCoord2 : INTERP3;
             float3 positionWS : INTERP4;
             float3 normalWS : INTERP5;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Wave_1_All_Color;
        float _Strength_2;
        float Wave_1_Scale;
        float Wave_3_Move_X;
        float Wave_1_Move_X;
        float Wave_1_Move_Y;
        float Wave_3_Move_Y;
        float Wave_1_Height;
        float2 Wave_3_Scale_B;
        float Wave_2_Height;
        float Wave_1_Time;
        float Wave_3_Normal_Strngth_A;
        float4 Water_Body_Color;
        float4 Wave_Edge_Color;
        float Refraction;
        float Opague_Level;
        float Wave_2_Scale;
        float Wave_2_Horiz_Shake;
        float Wave_2_Horiz_Shake_Scale;
        float Wave_2_Time;
        float Wave_3_Normal_Strngth_B;
        float _Smoothhness;
        float _DepthStrength;
        float _DepthDistribution;
        float4 Wave_3_Texture_TexelSize;
        float _Occlusion;
        float _Wave_1_Normal_Strngth;
        float _Foam_Scale;
        float _FoamDistribution;
        float _FoamStrength;
        float4 _FoamTexture_TexelSize;
        float4 _FoamColor;
        float _EdgeBlendStrength;
        float _EdgeBlendDistribution;
        float _Enable_Foam;
        float _Xtra_Mode;
        float2 Wave_3_Scale_A;
        float _Wave_1_Mode_B;
        float _Foam_Bump;
        float _Wave_4_Enable;
        float _Strength_1;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Wave_3_Texture);
        SAMPLER(samplerWave_3_Texture);
        TEXTURE2D(_FoamTexture);
        SAMPLER(sampler_FoamTexture);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING) && defined(RAYTRACING_SHADER_GRAPH_DEFAULT)
                    #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            float3 worldDerivativeX = ddx(Position);
            float3 worldDerivativeY = ddy(Position);
        
            float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
            float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
            float d = dot(worldDerivativeX, crossY);
            float sgn = d < 0.0 ? (-1.0f) : 1.0f;
            float surface = sgn / max(0.000000000000001192093f, abs(d));
        
            float dHdx = ddx(In);
            float dHdy = ddy(In);
            float3 surfGrad = surface * (dHdx*crossY + dHdy*crossX);
            Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
            Out = TransformWorldToTangent(Out, TangentMatrix);
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float = Wave_2_Scale;
            float2 _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2 = _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float.xx;
            float _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float = Wave_2_Time;
            float _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float, _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float);
            float2 _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2 = _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float.xx;
            float2 _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2, _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2, _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2);
            float _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float = Wave_2_Horiz_Shake_Scale;
            float _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float, _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float);
            float _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float;
            Unity_Power_float(_GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float, float(1), _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float);
            float3 _Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3 = _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float.xxx;
            float _Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float = Wave_2_Horiz_Shake;
            float _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float;
            Unity_Multiply_float_float(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, -1, _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3 = float3(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, float(0), _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3, _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3, _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3);
            float _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, float(1), _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float);
            float3 _Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3 = _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float.xxx;
            float _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float = Wave_2_Height;
            float3 _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3 = _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float.xxx;
            float3 _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3, _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3, _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3);
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float);
            float3 _Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3 = _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float.xxx;
            float _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float = Wave_1_Height;
            float3 _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3 = _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float.xxx;
            float3 _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3, _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3);
            float3 _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3;
            Unity_Add_float3(_Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3, _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3);
            float3 _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3 = _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3.xxx;
            float3 _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3, _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3);
            float3 _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3);
            float3 _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3, _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3);
            description.Position = _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float _Split_377b3c010ba5423dba14ec331c426c3d_R_1_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[0];
            float _Split_377b3c010ba5423dba14ec331c426c3d_G_2_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[1];
            float _Split_377b3c010ba5423dba14ec331c426c3d_B_3_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[2];
            float _Split_377b3c010ba5423dba14ec331c426c3d_A_4_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[3];
            float4 _Combine_7dfc15beb2a04d4291883bc04854c79e_RGBA_4_Vector4;
            float3 _Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3;
            float2 _Combine_7dfc15beb2a04d4291883bc04854c79e_RG_6_Vector2;
            Unity_Combine_float(_Split_377b3c010ba5423dba14ec331c426c3d_R_1_Float, _Split_377b3c010ba5423dba14ec331c426c3d_G_2_Float, _Split_377b3c010ba5423dba14ec331c426c3d_B_3_Float, float(0), _Combine_7dfc15beb2a04d4291883bc04854c79e_RGBA_4_Vector4, _Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3, _Combine_7dfc15beb2a04d4291883bc04854c79e_RG_6_Vector2);
            float _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, 0.1, _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float);
            float2 _Swizzle_005eadd84e55420d95c2c90dbae55f7c_Out_1_Vector2 = _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float.xx;
            float2 _TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (3, 3), _Swizzle_005eadd84e55420d95c2c90dbae55f7c_Out_1_Vector2, _TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2);
            float _GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2, float(10), _GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float);
            float3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3;
            float3x3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float,float(0.01),_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Position,_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_TangentMatrix, _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3);
            float _Float_20bc6059eb2146249c66329a2b699797_Out_0_Float = float(0.5);
            float3 _Swizzle_76a324a4c91f45a5a7504dad5e2e02de_Out_1_Vector3 = _Float_20bc6059eb2146249c66329a2b699797_Out_0_Float.xxx;
            float3 _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3;
            Unity_Multiply_float3_float3(_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3, _Swizzle_76a324a4c91f45a5a7504dad5e2e02de_Out_1_Vector3, _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3);
            float3 _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3;
            Unity_Add_float3(_Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3, _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3, _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3);
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_R_1_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[0];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_G_2_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[1];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_B_3_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[2];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_A_4_Float = 0;
            float4 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4;
            float3 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGB_5_Vector3;
            float2 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RG_6_Vector2;
            Unity_Combine_float(_Split_7bbe9fedaece4341a083f7f43b6b7d9c_R_1_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_G_2_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_B_3_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_A_4_Float, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGB_5_Vector3, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RG_6_Vector2);
            float3 _SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3;
            Unity_SceneColor_float(_Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4, _SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3);
            float _Property_54712e7ba1864687818d8f787ade3ea7_Out_0_Boolean = _Enable_Foam;
            float4 _Property_890d31ab96654e4bac11c748bf7e4641_Out_0_Vector4 = Water_Body_Color;
            float4 _Property_99e2b40349d44a0d8668aaa14c8b804a_Out_0_Vector4 = Wave_Edge_Color;
            float _Property_1040787057b04f1ea1a2f59828591d48_Out_0_Boolean = _Wave_1_All_Color;
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float;
            float _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float, _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Cells_4_Float);
            float2 _Swizzle_da99028e9d4548e385c610ae7868a193_Out_1_Vector2 = _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float.xx;
            float _RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_da99028e9d4548e385c610ae7868a193_Out_1_Vector2, float(0), float(0.3), _RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float);
            float _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float;
            float _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float, _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Cells_4_Float);
            float2 _Swizzle_2f9c4fb7696e40bb878c9342a7d03e34_Out_1_Vector2 = _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float.xx;
            float _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_2f9c4fb7696e40bb878c9342a7d03e34_Out_1_Vector2, float(0), float(0.3), _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float);
            float _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float;
            Unity_Multiply_float_float(_RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float, _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float, _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float);
            float _Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float, 2, _Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float);
            float _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float;
            Unity_OneMinus_float(_Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float, _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float);
            float _Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float;
            Unity_Multiply_float_float(_Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float, _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float, _Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float);
            float _Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float;
            Unity_Add_float(_Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float, _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float, _Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float);
            float _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float;
            Unity_Multiply_float_float(2, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float);
            float _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float;
            float _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Cells_4_Float);
            float _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float;
            Unity_Multiply_float_float(_Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float);
            float _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float;
            float _Voronoi_035e66672cf64440a56080bd42c7e2c2_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, float(7), _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float, _Voronoi_035e66672cf64440a56080bd42c7e2c2_Cells_4_Float);
            float _Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float;
            Unity_Smoothstep_float(float(0.36), float(0.72), _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float, _Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float);
            float _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float;
            Unity_Multiply_float_float(_Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float, 2, _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float);
            float _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float);
            float _Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float;
            Unity_Branch_float(_Property_1040787057b04f1ea1a2f59828591d48_Out_0_Boolean, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float, _Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float);
            float _SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float);
            float _Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float, _ProjectionParams.z, _Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float);
            float4 _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_R_1_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[0];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_G_2_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[1];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_B_3_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[2];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_A_4_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[3];
            float _Property_5dabeb8853164aaeb4e988181b8b9720_Out_0_Float = _DepthDistribution;
            float _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float;
            Unity_Add_float(_Split_e2f25dd3151246ae92c42ad9f084fb08_A_4_Float, _Property_5dabeb8853164aaeb4e988181b8b9720_Out_0_Float, _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float);
            float _Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float;
            Unity_Subtract_float(_Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float, _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float, _Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float);
            float _Property_508048d246254e00a116b88e267b1bd3_Out_0_Float = _DepthStrength;
            float _Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float, _Property_508048d246254e00a116b88e267b1bd3_Out_0_Float, _Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float);
            float _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float;
            Unity_Clamp_float(_Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float, float(0), float(1), _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float);
            float _Add_99516d93816e4273a3908308f95ba225_Out_2_Float;
            Unity_Add_float(_Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float, _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float, _Add_99516d93816e4273a3908308f95ba225_Out_2_Float);
            float4 _Swizzle_b11ae10f0a10468687eadd49fdddf366_Out_1_Vector4 = _Add_99516d93816e4273a3908308f95ba225_Out_2_Float.xxxx;
            float4 _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4;
            Unity_Lerp_float4(_Property_890d31ab96654e4bac11c748bf7e4641_Out_0_Vector4, _Property_99e2b40349d44a0d8668aaa14c8b804a_Out_0_Vector4, _Swizzle_b11ae10f0a10468687eadd49fdddf366_Out_1_Vector4, _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4);
            UnityTexture2D _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FoamTexture);
            float _Property_8ef00f5e8e19461f886a826695043dff_Out_0_Float = _Foam_Scale;
            float2 _Swizzle_6b00ff458ce142748a4b9e894f8e7bdc_Out_1_Vector2 = _Property_8ef00f5e8e19461f886a826695043dff_Out_0_Float.xx;
            float2 _TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6b00ff458ce142748a4b9e894f8e7bdc_Out_1_Vector2, float2 (0, 0), _TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2);
            float4 _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.tex, _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.samplerstate, _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2) );
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_R_4_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.r;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_G_5_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.g;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_B_6_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.b;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_A_7_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.a;
            float _SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float);
            float _Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float, _ProjectionParams.z, _Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float);
            float4 _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_6ee40854a2c6485fa13841cd79a811a4_R_1_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[0];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_G_2_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[1];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_B_3_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[2];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_A_4_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[3];
            float _Property_59a107015d234919a23075e0493479e7_Out_0_Float = _FoamDistribution;
            float _Add_02ef2739da7b419e99743253dd542709_Out_2_Float;
            Unity_Add_float(_Split_6ee40854a2c6485fa13841cd79a811a4_A_4_Float, _Property_59a107015d234919a23075e0493479e7_Out_0_Float, _Add_02ef2739da7b419e99743253dd542709_Out_2_Float);
            float _Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float;
            Unity_Subtract_float(_Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float, _Add_02ef2739da7b419e99743253dd542709_Out_2_Float, _Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float);
            float _Property_cd578333159d4940b9d2322e37be49e9_Out_0_Float = _FoamStrength;
            float _Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float, _Property_cd578333159d4940b9d2322e37be49e9_Out_0_Float, _Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float);
            float _Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float;
            Unity_Clamp_float(_Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float, float(0), float(1), _Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float);
            float _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float;
            Unity_Smoothstep_float(_Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float, float(2), _SampleTexture2D_eca122bc311046819a95157ab43caa94_A_7_Float, _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float);
            float4 _Swizzle_6ade92d2005e4e7894588a26122a9d4c_Out_1_Vector4 = _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float.xxxx;
            float4 _Property_7d76aa18002a4bb488b56e6e3af24842_Out_0_Vector4 = _FoamColor;
            float4 _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Swizzle_6ade92d2005e4e7894588a26122a9d4c_Out_1_Vector4, _Property_7d76aa18002a4bb488b56e6e3af24842_Out_0_Vector4, _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4);
            float4 _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4, _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4, _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4, _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4);
            float4 _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4;
            Unity_Branch_float4(_Property_54712e7ba1864687818d8f787ade3ea7_Out_0_Boolean, _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4, _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4, _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4);
            float _Split_98cb72d2146c4089be6ecde42edf59df_R_1_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[0];
            float _Split_98cb72d2146c4089be6ecde42edf59df_G_2_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[1];
            float _Split_98cb72d2146c4089be6ecde42edf59df_B_3_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[2];
            float _Split_98cb72d2146c4089be6ecde42edf59df_A_4_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[3];
            float4 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGBA_4_Vector4;
            float3 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3;
            float2 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RG_6_Vector2;
            Unity_Combine_float(_Split_98cb72d2146c4089be6ecde42edf59df_R_1_Float, _Split_98cb72d2146c4089be6ecde42edf59df_G_2_Float, _Split_98cb72d2146c4089be6ecde42edf59df_B_3_Float, float(0), _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGBA_4_Vector4, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RG_6_Vector2);
            float _Property_3f8b7b25769046f6b3af783a32563bb9_Out_0_Float = Refraction;
            float3 _Swizzle_501785d1544c49919e6cc3f890a170ef_Out_1_Vector3 = _Property_3f8b7b25769046f6b3af783a32563bb9_Out_0_Float.xxx;
            float3 _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3;
            Unity_Lerp_float3(_SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3, _Swizzle_501785d1544c49919e6cc3f890a170ef_Out_1_Vector3, _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3);
            float _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float);
            float _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float, _ProjectionParams.z, _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float);
            float4 _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_f4c2a8f4b03347289c6dc876561794f6_R_1_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[0];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_G_2_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[1];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_B_3_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[2];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[3];
            float _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float = _EdgeBlendDistribution;
            float _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float;
            Unity_Add_float(_Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float, _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float);
            float _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float;
            Unity_Subtract_float(_Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float, _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float);
            float _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float = _EdgeBlendStrength;
            float _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float, _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float, _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float);
            float _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float;
            Unity_Clamp_float(_Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float, float(0), float(1), _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float);
            float _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float;
            Unity_Multiply_float_float(2, _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float, _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float);
            float _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float = Opague_Level;
            float _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float, _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float, _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float);
            surface.BaseColor = _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Wave_1_All_Color;
        float _Strength_2;
        float Wave_1_Scale;
        float Wave_3_Move_X;
        float Wave_1_Move_X;
        float Wave_1_Move_Y;
        float Wave_3_Move_Y;
        float Wave_1_Height;
        float2 Wave_3_Scale_B;
        float Wave_2_Height;
        float Wave_1_Time;
        float Wave_3_Normal_Strngth_A;
        float4 Water_Body_Color;
        float4 Wave_Edge_Color;
        float Refraction;
        float Opague_Level;
        float Wave_2_Scale;
        float Wave_2_Horiz_Shake;
        float Wave_2_Horiz_Shake_Scale;
        float Wave_2_Time;
        float Wave_3_Normal_Strngth_B;
        float _Smoothhness;
        float _DepthStrength;
        float _DepthDistribution;
        float4 Wave_3_Texture_TexelSize;
        float _Occlusion;
        float _Wave_1_Normal_Strngth;
        float _Foam_Scale;
        float _FoamDistribution;
        float _FoamStrength;
        float4 _FoamTexture_TexelSize;
        float4 _FoamColor;
        float _EdgeBlendStrength;
        float _EdgeBlendDistribution;
        float _Enable_Foam;
        float _Xtra_Mode;
        float2 Wave_3_Scale_A;
        float _Wave_1_Mode_B;
        float _Foam_Bump;
        float _Wave_4_Enable;
        float _Strength_1;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Wave_3_Texture);
        SAMPLER(samplerWave_3_Texture);
        TEXTURE2D(_FoamTexture);
        SAMPLER(sampler_FoamTexture);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float = Wave_2_Scale;
            float2 _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2 = _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float.xx;
            float _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float = Wave_2_Time;
            float _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float, _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float);
            float2 _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2 = _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float.xx;
            float2 _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2, _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2, _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2);
            float _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float = Wave_2_Horiz_Shake_Scale;
            float _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float, _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float);
            float _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float;
            Unity_Power_float(_GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float, float(1), _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float);
            float3 _Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3 = _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float.xxx;
            float _Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float = Wave_2_Horiz_Shake;
            float _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float;
            Unity_Multiply_float_float(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, -1, _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3 = float3(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, float(0), _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3, _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3, _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3);
            float _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, float(1), _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float);
            float3 _Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3 = _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float.xxx;
            float _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float = Wave_2_Height;
            float3 _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3 = _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float.xxx;
            float3 _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3, _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3, _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3);
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float);
            float3 _Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3 = _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float.xxx;
            float _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float = Wave_1_Height;
            float3 _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3 = _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float.xxx;
            float3 _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3, _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3);
            float3 _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3;
            Unity_Add_float3(_Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3, _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3);
            float3 _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3 = _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3.xxx;
            float3 _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3, _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3);
            float3 _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3);
            float3 _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3, _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3);
            description.Position = _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float);
            float _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float, _ProjectionParams.z, _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float);
            float4 _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_f4c2a8f4b03347289c6dc876561794f6_R_1_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[0];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_G_2_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[1];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_B_3_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[2];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[3];
            float _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float = _EdgeBlendDistribution;
            float _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float;
            Unity_Add_float(_Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float, _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float);
            float _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float;
            Unity_Subtract_float(_Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float, _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float);
            float _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float = _EdgeBlendStrength;
            float _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float, _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float, _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float);
            float _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float;
            Unity_Clamp_float(_Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float, float(0), float(1), _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float);
            float _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float;
            Unity_Multiply_float_float(2, _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float, _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float);
            float _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float = Opague_Level;
            float _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float, _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float, _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float);
            surface.Alpha = _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float3 positionWS : INTERP2;
             float3 normalWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Wave_1_All_Color;
        float _Strength_2;
        float Wave_1_Scale;
        float Wave_3_Move_X;
        float Wave_1_Move_X;
        float Wave_1_Move_Y;
        float Wave_3_Move_Y;
        float Wave_1_Height;
        float2 Wave_3_Scale_B;
        float Wave_2_Height;
        float Wave_1_Time;
        float Wave_3_Normal_Strngth_A;
        float4 Water_Body_Color;
        float4 Wave_Edge_Color;
        float Refraction;
        float Opague_Level;
        float Wave_2_Scale;
        float Wave_2_Horiz_Shake;
        float Wave_2_Horiz_Shake_Scale;
        float Wave_2_Time;
        float Wave_3_Normal_Strngth_B;
        float _Smoothhness;
        float _DepthStrength;
        float _DepthDistribution;
        float4 Wave_3_Texture_TexelSize;
        float _Occlusion;
        float _Wave_1_Normal_Strngth;
        float _Foam_Scale;
        float _FoamDistribution;
        float _FoamStrength;
        float4 _FoamTexture_TexelSize;
        float4 _FoamColor;
        float _EdgeBlendStrength;
        float _EdgeBlendDistribution;
        float _Enable_Foam;
        float _Xtra_Mode;
        float2 Wave_3_Scale_A;
        float _Wave_1_Mode_B;
        float _Foam_Bump;
        float _Wave_4_Enable;
        float _Strength_1;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Wave_3_Texture);
        SAMPLER(samplerWave_3_Texture);
        TEXTURE2D(_FoamTexture);
        SAMPLER(sampler_FoamTexture);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING) && defined(RAYTRACING_SHADER_GRAPH_DEFAULT)
                    #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            float3 worldDerivativeX = ddx(Position);
            float3 worldDerivativeY = ddy(Position);
        
            float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
            float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
            float d = dot(worldDerivativeX, crossY);
            float sgn = d < 0.0 ? (-1.0f) : 1.0f;
            float surface = sgn / max(0.000000000000001192093f, abs(d));
        
            float dHdx = ddx(In);
            float dHdy = ddy(In);
            float3 surfGrad = surface * (dHdx*crossY + dHdy*crossX);
            Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
            Out = TransformWorldToTangent(Out, TangentMatrix);
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float = Wave_2_Scale;
            float2 _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2 = _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float.xx;
            float _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float = Wave_2_Time;
            float _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float, _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float);
            float2 _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2 = _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float.xx;
            float2 _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2, _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2, _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2);
            float _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float = Wave_2_Horiz_Shake_Scale;
            float _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float, _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float);
            float _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float;
            Unity_Power_float(_GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float, float(1), _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float);
            float3 _Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3 = _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float.xxx;
            float _Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float = Wave_2_Horiz_Shake;
            float _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float;
            Unity_Multiply_float_float(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, -1, _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3 = float3(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, float(0), _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3, _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3, _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3);
            float _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, float(1), _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float);
            float3 _Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3 = _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float.xxx;
            float _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float = Wave_2_Height;
            float3 _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3 = _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float.xxx;
            float3 _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3, _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3, _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3);
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float);
            float3 _Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3 = _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float.xxx;
            float _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float = Wave_1_Height;
            float3 _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3 = _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float.xxx;
            float3 _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3, _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3);
            float3 _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3;
            Unity_Add_float3(_Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3, _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3);
            float3 _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3 = _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3.xxx;
            float3 _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3, _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3);
            float3 _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3);
            float3 _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3, _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3);
            description.Position = _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float _Split_377b3c010ba5423dba14ec331c426c3d_R_1_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[0];
            float _Split_377b3c010ba5423dba14ec331c426c3d_G_2_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[1];
            float _Split_377b3c010ba5423dba14ec331c426c3d_B_3_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[2];
            float _Split_377b3c010ba5423dba14ec331c426c3d_A_4_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[3];
            float4 _Combine_7dfc15beb2a04d4291883bc04854c79e_RGBA_4_Vector4;
            float3 _Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3;
            float2 _Combine_7dfc15beb2a04d4291883bc04854c79e_RG_6_Vector2;
            Unity_Combine_float(_Split_377b3c010ba5423dba14ec331c426c3d_R_1_Float, _Split_377b3c010ba5423dba14ec331c426c3d_G_2_Float, _Split_377b3c010ba5423dba14ec331c426c3d_B_3_Float, float(0), _Combine_7dfc15beb2a04d4291883bc04854c79e_RGBA_4_Vector4, _Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3, _Combine_7dfc15beb2a04d4291883bc04854c79e_RG_6_Vector2);
            float _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, 0.1, _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float);
            float2 _Swizzle_005eadd84e55420d95c2c90dbae55f7c_Out_1_Vector2 = _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float.xx;
            float2 _TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (3, 3), _Swizzle_005eadd84e55420d95c2c90dbae55f7c_Out_1_Vector2, _TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2);
            float _GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2, float(10), _GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float);
            float3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3;
            float3x3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float,float(0.01),_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Position,_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_TangentMatrix, _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3);
            float _Float_20bc6059eb2146249c66329a2b699797_Out_0_Float = float(0.5);
            float3 _Swizzle_76a324a4c91f45a5a7504dad5e2e02de_Out_1_Vector3 = _Float_20bc6059eb2146249c66329a2b699797_Out_0_Float.xxx;
            float3 _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3;
            Unity_Multiply_float3_float3(_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3, _Swizzle_76a324a4c91f45a5a7504dad5e2e02de_Out_1_Vector3, _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3);
            float3 _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3;
            Unity_Add_float3(_Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3, _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3, _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3);
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_R_1_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[0];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_G_2_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[1];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_B_3_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[2];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_A_4_Float = 0;
            float4 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4;
            float3 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGB_5_Vector3;
            float2 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RG_6_Vector2;
            Unity_Combine_float(_Split_7bbe9fedaece4341a083f7f43b6b7d9c_R_1_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_G_2_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_B_3_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_A_4_Float, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGB_5_Vector3, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RG_6_Vector2);
            float3 _SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3;
            Unity_SceneColor_float(_Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4, _SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3);
            float _Property_54712e7ba1864687818d8f787ade3ea7_Out_0_Boolean = _Enable_Foam;
            float4 _Property_890d31ab96654e4bac11c748bf7e4641_Out_0_Vector4 = Water_Body_Color;
            float4 _Property_99e2b40349d44a0d8668aaa14c8b804a_Out_0_Vector4 = Wave_Edge_Color;
            float _Property_1040787057b04f1ea1a2f59828591d48_Out_0_Boolean = _Wave_1_All_Color;
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float;
            float _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float, _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Cells_4_Float);
            float2 _Swizzle_da99028e9d4548e385c610ae7868a193_Out_1_Vector2 = _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float.xx;
            float _RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_da99028e9d4548e385c610ae7868a193_Out_1_Vector2, float(0), float(0.3), _RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float);
            float _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float;
            float _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float, _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Cells_4_Float);
            float2 _Swizzle_2f9c4fb7696e40bb878c9342a7d03e34_Out_1_Vector2 = _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float.xx;
            float _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_2f9c4fb7696e40bb878c9342a7d03e34_Out_1_Vector2, float(0), float(0.3), _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float);
            float _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float;
            Unity_Multiply_float_float(_RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float, _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float, _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float);
            float _Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float, 2, _Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float);
            float _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float;
            Unity_OneMinus_float(_Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float, _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float);
            float _Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float;
            Unity_Multiply_float_float(_Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float, _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float, _Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float);
            float _Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float;
            Unity_Add_float(_Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float, _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float, _Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float);
            float _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float;
            Unity_Multiply_float_float(2, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float);
            float _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float;
            float _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Cells_4_Float);
            float _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float;
            Unity_Multiply_float_float(_Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float);
            float _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float;
            float _Voronoi_035e66672cf64440a56080bd42c7e2c2_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, float(7), _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float, _Voronoi_035e66672cf64440a56080bd42c7e2c2_Cells_4_Float);
            float _Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float;
            Unity_Smoothstep_float(float(0.36), float(0.72), _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float, _Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float);
            float _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float;
            Unity_Multiply_float_float(_Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float, 2, _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float);
            float _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float);
            float _Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float;
            Unity_Branch_float(_Property_1040787057b04f1ea1a2f59828591d48_Out_0_Boolean, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float, _Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float);
            float _SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float);
            float _Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float, _ProjectionParams.z, _Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float);
            float4 _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_R_1_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[0];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_G_2_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[1];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_B_3_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[2];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_A_4_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[3];
            float _Property_5dabeb8853164aaeb4e988181b8b9720_Out_0_Float = _DepthDistribution;
            float _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float;
            Unity_Add_float(_Split_e2f25dd3151246ae92c42ad9f084fb08_A_4_Float, _Property_5dabeb8853164aaeb4e988181b8b9720_Out_0_Float, _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float);
            float _Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float;
            Unity_Subtract_float(_Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float, _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float, _Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float);
            float _Property_508048d246254e00a116b88e267b1bd3_Out_0_Float = _DepthStrength;
            float _Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float, _Property_508048d246254e00a116b88e267b1bd3_Out_0_Float, _Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float);
            float _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float;
            Unity_Clamp_float(_Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float, float(0), float(1), _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float);
            float _Add_99516d93816e4273a3908308f95ba225_Out_2_Float;
            Unity_Add_float(_Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float, _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float, _Add_99516d93816e4273a3908308f95ba225_Out_2_Float);
            float4 _Swizzle_b11ae10f0a10468687eadd49fdddf366_Out_1_Vector4 = _Add_99516d93816e4273a3908308f95ba225_Out_2_Float.xxxx;
            float4 _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4;
            Unity_Lerp_float4(_Property_890d31ab96654e4bac11c748bf7e4641_Out_0_Vector4, _Property_99e2b40349d44a0d8668aaa14c8b804a_Out_0_Vector4, _Swizzle_b11ae10f0a10468687eadd49fdddf366_Out_1_Vector4, _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4);
            UnityTexture2D _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FoamTexture);
            float _Property_8ef00f5e8e19461f886a826695043dff_Out_0_Float = _Foam_Scale;
            float2 _Swizzle_6b00ff458ce142748a4b9e894f8e7bdc_Out_1_Vector2 = _Property_8ef00f5e8e19461f886a826695043dff_Out_0_Float.xx;
            float2 _TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6b00ff458ce142748a4b9e894f8e7bdc_Out_1_Vector2, float2 (0, 0), _TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2);
            float4 _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.tex, _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.samplerstate, _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2) );
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_R_4_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.r;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_G_5_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.g;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_B_6_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.b;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_A_7_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.a;
            float _SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float);
            float _Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float, _ProjectionParams.z, _Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float);
            float4 _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_6ee40854a2c6485fa13841cd79a811a4_R_1_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[0];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_G_2_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[1];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_B_3_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[2];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_A_4_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[3];
            float _Property_59a107015d234919a23075e0493479e7_Out_0_Float = _FoamDistribution;
            float _Add_02ef2739da7b419e99743253dd542709_Out_2_Float;
            Unity_Add_float(_Split_6ee40854a2c6485fa13841cd79a811a4_A_4_Float, _Property_59a107015d234919a23075e0493479e7_Out_0_Float, _Add_02ef2739da7b419e99743253dd542709_Out_2_Float);
            float _Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float;
            Unity_Subtract_float(_Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float, _Add_02ef2739da7b419e99743253dd542709_Out_2_Float, _Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float);
            float _Property_cd578333159d4940b9d2322e37be49e9_Out_0_Float = _FoamStrength;
            float _Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float, _Property_cd578333159d4940b9d2322e37be49e9_Out_0_Float, _Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float);
            float _Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float;
            Unity_Clamp_float(_Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float, float(0), float(1), _Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float);
            float _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float;
            Unity_Smoothstep_float(_Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float, float(2), _SampleTexture2D_eca122bc311046819a95157ab43caa94_A_7_Float, _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float);
            float4 _Swizzle_6ade92d2005e4e7894588a26122a9d4c_Out_1_Vector4 = _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float.xxxx;
            float4 _Property_7d76aa18002a4bb488b56e6e3af24842_Out_0_Vector4 = _FoamColor;
            float4 _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Swizzle_6ade92d2005e4e7894588a26122a9d4c_Out_1_Vector4, _Property_7d76aa18002a4bb488b56e6e3af24842_Out_0_Vector4, _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4);
            float4 _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4, _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4, _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4, _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4);
            float4 _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4;
            Unity_Branch_float4(_Property_54712e7ba1864687818d8f787ade3ea7_Out_0_Boolean, _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4, _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4, _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4);
            float _Split_98cb72d2146c4089be6ecde42edf59df_R_1_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[0];
            float _Split_98cb72d2146c4089be6ecde42edf59df_G_2_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[1];
            float _Split_98cb72d2146c4089be6ecde42edf59df_B_3_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[2];
            float _Split_98cb72d2146c4089be6ecde42edf59df_A_4_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[3];
            float4 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGBA_4_Vector4;
            float3 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3;
            float2 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RG_6_Vector2;
            Unity_Combine_float(_Split_98cb72d2146c4089be6ecde42edf59df_R_1_Float, _Split_98cb72d2146c4089be6ecde42edf59df_G_2_Float, _Split_98cb72d2146c4089be6ecde42edf59df_B_3_Float, float(0), _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGBA_4_Vector4, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RG_6_Vector2);
            float _Property_3f8b7b25769046f6b3af783a32563bb9_Out_0_Float = Refraction;
            float3 _Swizzle_501785d1544c49919e6cc3f890a170ef_Out_1_Vector3 = _Property_3f8b7b25769046f6b3af783a32563bb9_Out_0_Float.xxx;
            float3 _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3;
            Unity_Lerp_float3(_SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3, _Swizzle_501785d1544c49919e6cc3f890a170ef_Out_1_Vector3, _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3);
            float _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float);
            float _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float, _ProjectionParams.z, _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float);
            float4 _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_f4c2a8f4b03347289c6dc876561794f6_R_1_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[0];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_G_2_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[1];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_B_3_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[2];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[3];
            float _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float = _EdgeBlendDistribution;
            float _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float;
            Unity_Add_float(_Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float, _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float);
            float _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float;
            Unity_Subtract_float(_Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float, _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float);
            float _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float = _EdgeBlendStrength;
            float _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float, _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float, _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float);
            float _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float;
            Unity_Clamp_float(_Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float, float(0), float(1), _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float);
            float _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float;
            Unity_Multiply_float_float(2, _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float, _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float);
            float _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float = Opague_Level;
            float _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float, _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float, _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float);
            surface.BaseColor = _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3;
            surface.Alpha = _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Universal 2D"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float3 positionWS : INTERP2;
             float3 normalWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Wave_1_All_Color;
        float _Strength_2;
        float Wave_1_Scale;
        float Wave_3_Move_X;
        float Wave_1_Move_X;
        float Wave_1_Move_Y;
        float Wave_3_Move_Y;
        float Wave_1_Height;
        float2 Wave_3_Scale_B;
        float Wave_2_Height;
        float Wave_1_Time;
        float Wave_3_Normal_Strngth_A;
        float4 Water_Body_Color;
        float4 Wave_Edge_Color;
        float Refraction;
        float Opague_Level;
        float Wave_2_Scale;
        float Wave_2_Horiz_Shake;
        float Wave_2_Horiz_Shake_Scale;
        float Wave_2_Time;
        float Wave_3_Normal_Strngth_B;
        float _Smoothhness;
        float _DepthStrength;
        float _DepthDistribution;
        float4 Wave_3_Texture_TexelSize;
        float _Occlusion;
        float _Wave_1_Normal_Strngth;
        float _Foam_Scale;
        float _FoamDistribution;
        float _FoamStrength;
        float4 _FoamTexture_TexelSize;
        float4 _FoamColor;
        float _EdgeBlendStrength;
        float _EdgeBlendDistribution;
        float _Enable_Foam;
        float _Xtra_Mode;
        float2 Wave_3_Scale_A;
        float _Wave_1_Mode_B;
        float _Foam_Bump;
        float _Wave_4_Enable;
        float _Strength_1;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Wave_3_Texture);
        SAMPLER(samplerWave_3_Texture);
        TEXTURE2D(_FoamTexture);
        SAMPLER(sampler_FoamTexture);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING) && defined(RAYTRACING_SHADER_GRAPH_DEFAULT)
                    #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            float3 worldDerivativeX = ddx(Position);
            float3 worldDerivativeY = ddy(Position);
        
            float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
            float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
            float d = dot(worldDerivativeX, crossY);
            float sgn = d < 0.0 ? (-1.0f) : 1.0f;
            float surface = sgn / max(0.000000000000001192093f, abs(d));
        
            float dHdx = ddx(In);
            float dHdy = ddy(In);
            float3 surfGrad = surface * (dHdx*crossY + dHdy*crossX);
            Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
            Out = TransformWorldToTangent(Out, TangentMatrix);
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
        {
             float randomno =  frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
             Out = lerp(Min, Max, randomno);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_SceneDepth_Linear01_float(float4 UV, out float Out)
        {
            Out = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float = Wave_2_Scale;
            float2 _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2 = _Property_b88ca8f537b84d59a16af24edb90f2c2_Out_0_Float.xx;
            float _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float = Wave_2_Time;
            float _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9ccf72c995f14fe38fdce0c376aaba8d_Out_0_Float, _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float);
            float2 _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2 = _Multiply_b57ef6439d834103ad226f7dc8354017_Out_2_Float.xx;
            float2 _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6307e3db0943458fa83a464a738f90b5_Out_1_Vector2, _Swizzle_3c552e194c614718b52480996c52f11e_Out_1_Vector2, _TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2);
            float _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float = Wave_2_Horiz_Shake_Scale;
            float _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, _Property_8cfa343f58ec4b2db75220ff740afb3c_Out_0_Float, _GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float);
            float _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float;
            Unity_Power_float(_GradientNoise_56e98f60c83d4a2a852ab1c58284ddff_Out_2_Float, float(1), _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float);
            float3 _Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3 = _Power_e7aa85c449fa41e4915e823d4c061ca5_Out_2_Float.xxx;
            float _Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float = Wave_2_Horiz_Shake;
            float _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float;
            Unity_Multiply_float_float(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, -1, _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3 = float3(_Property_a04830acd7434bf3bddab36dbd1c5c1a_Out_0_Float, float(0), _Multiply_e5241b4237b64cbdb62c3057c9cb5173_Out_2_Float);
            float3 _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_28819e20a48e419fa1c2256232741fa5_Out_1_Vector3, _Vector3_772736d40e9f49dcb6e6394a6df7a7dc_Out_0_Vector3, _Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3);
            float _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_f2463d3eb7bb45f6b2e956981d7953f0_Out_3_Vector2, float(1), _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float);
            float3 _Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3 = _GradientNoise_be02b628a76c4d3fb8a7de92a2a04931_Out_2_Float.xxx;
            float _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float = Wave_2_Height;
            float3 _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3 = _Property_f60d2088588b40dab3f63dcdc8d420c8_Out_0_Float.xxx;
            float3 _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_2946b29389304658a60ad45800fd130f_Out_1_Vector3, _Swizzle_5e046e3de7f546ac851eb1d9db0f1793_Out_1_Vector3, _Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3);
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float;
            float _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float, _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Cells_4_Float);
            float3 _Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3 = _Voronoi_5dc6b81f68d6488497f5f1f4c133ae95_Out_3_Float.xxx;
            float _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float = Wave_1_Height;
            float3 _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3 = _Property_95f695bf1dba481ea84efae5617380aa_Out_0_Float.xxx;
            float3 _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Swizzle_32709382d05a4d2d8897c5110d29ef91_Out_1_Vector3, _Swizzle_2db97bdd44964743ae1342df50017fe5_Out_1_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3);
            float3 _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3;
            Unity_Add_float3(_Multiply_609e6b80e5bc4987a88b64420fbe4b54_Out_2_Vector3, _Multiply_24289fd91a4343b190b47329c20aa8b3_Out_2_Vector3, _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3);
            float3 _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3 = _Add_d20f8e508669499a8ad07bb142d809cc_Out_2_Vector3.xxx;
            float3 _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, _Swizzle_1938f7907d864b7fbd132e04daa905b2_Out_1_Vector3, _Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3);
            float3 _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3;
            Unity_Add_float3(_Multiply_184492548882482d96aaf26cdfabfa5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3);
            float3 _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            Unity_Add_float3(_Multiply_c542557aec6e4d4689aa16da5e2008e1_Out_2_Vector3, _Add_ea45d0e93fbb4c86b6f2ecd5c260ec5d_Out_2_Vector3, _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3);
            description.Position = _Add_c33abdfb2c7c47d7b0213cc14c207298_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4 = float4(IN.NDCPosition.xy, 0, 0);
            float _Split_377b3c010ba5423dba14ec331c426c3d_R_1_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[0];
            float _Split_377b3c010ba5423dba14ec331c426c3d_G_2_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[1];
            float _Split_377b3c010ba5423dba14ec331c426c3d_B_3_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[2];
            float _Split_377b3c010ba5423dba14ec331c426c3d_A_4_Float = _ScreenPosition_eee8cd8d9e494433a8cb44a119477106_Out_0_Vector4[3];
            float4 _Combine_7dfc15beb2a04d4291883bc04854c79e_RGBA_4_Vector4;
            float3 _Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3;
            float2 _Combine_7dfc15beb2a04d4291883bc04854c79e_RG_6_Vector2;
            Unity_Combine_float(_Split_377b3c010ba5423dba14ec331c426c3d_R_1_Float, _Split_377b3c010ba5423dba14ec331c426c3d_G_2_Float, _Split_377b3c010ba5423dba14ec331c426c3d_B_3_Float, float(0), _Combine_7dfc15beb2a04d4291883bc04854c79e_RGBA_4_Vector4, _Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3, _Combine_7dfc15beb2a04d4291883bc04854c79e_RG_6_Vector2);
            float _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, 0.1, _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float);
            float2 _Swizzle_005eadd84e55420d95c2c90dbae55f7c_Out_1_Vector2 = _Multiply_7543c19e97dd4c458702250b91f21836_Out_2_Float.xx;
            float2 _TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (3, 3), _Swizzle_005eadd84e55420d95c2c90dbae55f7c_Out_1_Vector2, _TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2);
            float _GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_8fa54207c3a041a392a90eafb4cd41d8_Out_3_Vector2, float(10), _GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float);
            float3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3;
            float3x3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_GradientNoise_543d5faebfa74267b5bab3a9d108d65a_Out_2_Float,float(0.01),_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Position,_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_TangentMatrix, _NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3);
            float _Float_20bc6059eb2146249c66329a2b699797_Out_0_Float = float(0.5);
            float3 _Swizzle_76a324a4c91f45a5a7504dad5e2e02de_Out_1_Vector3 = _Float_20bc6059eb2146249c66329a2b699797_Out_0_Float.xxx;
            float3 _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3;
            Unity_Multiply_float3_float3(_NormalFromHeight_a3c4e9c3955e4a15b929e340c24e9999_Out_1_Vector3, _Swizzle_76a324a4c91f45a5a7504dad5e2e02de_Out_1_Vector3, _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3);
            float3 _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3;
            Unity_Add_float3(_Combine_7dfc15beb2a04d4291883bc04854c79e_RGB_5_Vector3, _Multiply_bd6b7c581d194147a9591d0e01a22316_Out_2_Vector3, _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3);
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_R_1_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[0];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_G_2_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[1];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_B_3_Float = _Add_9a905416964b4b3285bf4f76180001bd_Out_2_Vector3[2];
            float _Split_7bbe9fedaece4341a083f7f43b6b7d9c_A_4_Float = 0;
            float4 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4;
            float3 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGB_5_Vector3;
            float2 _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RG_6_Vector2;
            Unity_Combine_float(_Split_7bbe9fedaece4341a083f7f43b6b7d9c_R_1_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_G_2_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_B_3_Float, _Split_7bbe9fedaece4341a083f7f43b6b7d9c_A_4_Float, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGB_5_Vector3, _Combine_81406a3b9e9e4788b7afdb3a9f93d903_RG_6_Vector2);
            float3 _SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3;
            Unity_SceneColor_float(_Combine_81406a3b9e9e4788b7afdb3a9f93d903_RGBA_4_Vector4, _SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3);
            float _Property_54712e7ba1864687818d8f787ade3ea7_Out_0_Boolean = _Enable_Foam;
            float4 _Property_890d31ab96654e4bac11c748bf7e4641_Out_0_Vector4 = Water_Body_Color;
            float4 _Property_99e2b40349d44a0d8668aaa14c8b804a_Out_0_Vector4 = Wave_Edge_Color;
            float _Property_1040787057b04f1ea1a2f59828591d48_Out_0_Boolean = _Wave_1_All_Color;
            float _Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float = float(2);
            float _Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float = Wave_1_Move_X;
            float _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float = Wave_1_Move_Y;
            float2 _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2 = float2(_Property_544919488ccd4a3ead7986ca4f55895f_Out_0_Float, _Property_1790dffef32d4ffc8326372ada13a034_Out_0_Float);
            float2 _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2;
            Unity_Multiply_float2_float2((IN.TimeParameters.x.xx), _Vector2_ff853a7c02674ace8c863c33ba7e7efe_Out_0_Vector2, _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2);
            float2 _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2;
            Unity_Multiply_float2_float2((_Float_6b303abe7b5b42f49f362a73f60c1ffd_Out_0_Float.xx), _Multiply_7e50509dbd574df384455cab9c28128a_Out_2_Vector2, _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2);
            float2 _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_84ccac2b00c34ed2a5375da22dacb6a8_Out_2_Vector2, _TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2);
            float _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float = Wave_1_Time;
            float _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9e69a6e149154ebc991196c2a6e11954_Out_0_Float, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float);
            float _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float = Wave_1_Scale;
            float _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float;
            float _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float, _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Cells_4_Float);
            float2 _Swizzle_da99028e9d4548e385c610ae7868a193_Out_1_Vector2 = _Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float.xx;
            float _RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_da99028e9d4548e385c610ae7868a193_Out_1_Vector2, float(0), float(0.3), _RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float);
            float _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float;
            float _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float, _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Cells_4_Float);
            float2 _Swizzle_2f9c4fb7696e40bb878c9342a7d03e34_Out_1_Vector2 = _Voronoi_7f179e4bd58e459688ac854e6e323cc3_Out_3_Float.xx;
            float _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float;
            Unity_RandomRange_float(_Swizzle_2f9c4fb7696e40bb878c9342a7d03e34_Out_1_Vector2, float(0), float(0.3), _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float);
            float _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float;
            Unity_Multiply_float_float(_RandomRange_c14276dfa896422b8e372eacf570c483_Out_3_Float, _RandomRange_86a616afdf5c4f44a93e617954d7402c_Out_3_Float, _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float);
            float _Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float, 2, _Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float);
            float _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float;
            Unity_OneMinus_float(_Multiply_7a384c1f8045433799e436a4b01b9dbb_Out_2_Float, _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float);
            float _Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float;
            Unity_Multiply_float_float(_Voronoi_aeb1d1579cfc42038f15362260e02ff5_Out_3_Float, _OneMinus_6ea6cb0b15724fb3ab422dcfe7a9feb9_Out_1_Float, _Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float);
            float _Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float;
            Unity_Add_float(_Multiply_64e21967849e4971b9f162085a5441d4_Out_2_Float, _Multiply_74e9b5d0e09a4410b1c5fea4126271ac_Out_2_Float, _Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float);
            float _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float;
            Unity_Multiply_float_float(2, _Property_0ff0616e5c874e0d96e6f16049add012_Out_0_Float, _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float);
            float _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float;
            float _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, _Multiply_c17a387d39044c9f9eea8be86daef456_Out_2_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Cells_4_Float);
            float _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float;
            Unity_Multiply_float_float(_Add_c446c3dfa5db45ad8b309ffad2282fe5_Out_2_Float, _Voronoi_79efb494ea794dfca4a3f998eda2e0f1_Out_3_Float, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float);
            float _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float;
            float _Voronoi_035e66672cf64440a56080bd42c7e2c2_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c76976331968462ab4be702ec9110f62_Out_3_Vector2, _Multiply_6942a8afac2a446f8d0da574fc4d4108_Out_2_Float, float(7), _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float, _Voronoi_035e66672cf64440a56080bd42c7e2c2_Cells_4_Float);
            float _Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float;
            Unity_Smoothstep_float(float(0.36), float(0.72), _Voronoi_035e66672cf64440a56080bd42c7e2c2_Out_3_Float, _Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float);
            float _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float;
            Unity_Multiply_float_float(_Smoothstep_c7c15aea693f4ad08759ba75ec71bba8_Out_3_Float, 2, _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float);
            float _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Multiply_88c01a6b999849eeb9def16efb27dc82_Out_2_Float, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float);
            float _Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float;
            Unity_Branch_float(_Property_1040787057b04f1ea1a2f59828591d48_Out_0_Boolean, _Multiply_0436f9557eab4dc3a13fa162df1baee5_Out_2_Float, _Multiply_a7b7e3d4f575436a9954f91f844aaf82_Out_2_Float, _Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float);
            float _SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float);
            float _Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_56ad23e82ae644a298885b424d1abee2_Out_1_Float, _ProjectionParams.z, _Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float);
            float4 _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_R_1_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[0];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_G_2_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[1];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_B_3_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[2];
            float _Split_e2f25dd3151246ae92c42ad9f084fb08_A_4_Float = _ScreenPosition_4af9505b91454eabbb4f60b1e0c4db38_Out_0_Vector4[3];
            float _Property_5dabeb8853164aaeb4e988181b8b9720_Out_0_Float = _DepthDistribution;
            float _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float;
            Unity_Add_float(_Split_e2f25dd3151246ae92c42ad9f084fb08_A_4_Float, _Property_5dabeb8853164aaeb4e988181b8b9720_Out_0_Float, _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float);
            float _Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float;
            Unity_Subtract_float(_Multiply_86bea052d7d64e3289683bae7f5b76cd_Out_2_Float, _Add_0d90a83878164454a199100bc9aaf550_Out_2_Float, _Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float);
            float _Property_508048d246254e00a116b88e267b1bd3_Out_0_Float = _DepthStrength;
            float _Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_bc1fc1971d38435eb98540d6bd8488dd_Out_2_Float, _Property_508048d246254e00a116b88e267b1bd3_Out_0_Float, _Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float);
            float _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float;
            Unity_Clamp_float(_Multiply_ffa20fcd34924730895f85efb7339a2d_Out_2_Float, float(0), float(1), _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float);
            float _Add_99516d93816e4273a3908308f95ba225_Out_2_Float;
            Unity_Add_float(_Branch_bdf8b507a69c40a3856d5f7738f94fde_Out_3_Float, _Clamp_29edc10c75794ac794d2e8ff43bffa63_Out_3_Float, _Add_99516d93816e4273a3908308f95ba225_Out_2_Float);
            float4 _Swizzle_b11ae10f0a10468687eadd49fdddf366_Out_1_Vector4 = _Add_99516d93816e4273a3908308f95ba225_Out_2_Float.xxxx;
            float4 _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4;
            Unity_Lerp_float4(_Property_890d31ab96654e4bac11c748bf7e4641_Out_0_Vector4, _Property_99e2b40349d44a0d8668aaa14c8b804a_Out_0_Vector4, _Swizzle_b11ae10f0a10468687eadd49fdddf366_Out_1_Vector4, _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4);
            UnityTexture2D _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_FoamTexture);
            float _Property_8ef00f5e8e19461f886a826695043dff_Out_0_Float = _Foam_Scale;
            float2 _Swizzle_6b00ff458ce142748a4b9e894f8e7bdc_Out_1_Vector2 = _Property_8ef00f5e8e19461f886a826695043dff_Out_0_Float.xx;
            float2 _TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Swizzle_6b00ff458ce142748a4b9e894f8e7bdc_Out_1_Vector2, float2 (0, 0), _TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2);
            float4 _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.tex, _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.samplerstate, _Property_5015cd16b30f44e2b223db3e2d9f41c3_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1106090d66fe4d1a8dad7dda0a5dcb17_Out_3_Vector2) );
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_R_4_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.r;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_G_5_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.g;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_B_6_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.b;
            float _SampleTexture2D_eca122bc311046819a95157ab43caa94_A_7_Float = _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4.a;
            float _SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float);
            float _Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_418ae83ebb194e0ca3ddc12593a7c858_Out_1_Float, _ProjectionParams.z, _Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float);
            float4 _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_6ee40854a2c6485fa13841cd79a811a4_R_1_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[0];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_G_2_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[1];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_B_3_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[2];
            float _Split_6ee40854a2c6485fa13841cd79a811a4_A_4_Float = _ScreenPosition_60352cedca634f24aeb6f60d86d550a4_Out_0_Vector4[3];
            float _Property_59a107015d234919a23075e0493479e7_Out_0_Float = _FoamDistribution;
            float _Add_02ef2739da7b419e99743253dd542709_Out_2_Float;
            Unity_Add_float(_Split_6ee40854a2c6485fa13841cd79a811a4_A_4_Float, _Property_59a107015d234919a23075e0493479e7_Out_0_Float, _Add_02ef2739da7b419e99743253dd542709_Out_2_Float);
            float _Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float;
            Unity_Subtract_float(_Multiply_78cfa783fcd74e76b41fa76f02e3fa56_Out_2_Float, _Add_02ef2739da7b419e99743253dd542709_Out_2_Float, _Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float);
            float _Property_cd578333159d4940b9d2322e37be49e9_Out_0_Float = _FoamStrength;
            float _Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_4019dc4c5d2f4708871452e4bc621a2d_Out_2_Float, _Property_cd578333159d4940b9d2322e37be49e9_Out_0_Float, _Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float);
            float _Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float;
            Unity_Clamp_float(_Multiply_cbe37696b43943a485db4cd8e9d42a7a_Out_2_Float, float(0), float(1), _Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float);
            float _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float;
            Unity_Smoothstep_float(_Clamp_a113ca518391406cbd28041416c766d7_Out_3_Float, float(2), _SampleTexture2D_eca122bc311046819a95157ab43caa94_A_7_Float, _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float);
            float4 _Swizzle_6ade92d2005e4e7894588a26122a9d4c_Out_1_Vector4 = _Smoothstep_be91c982100b4af7b96a8f51d150b601_Out_3_Float.xxxx;
            float4 _Property_7d76aa18002a4bb488b56e6e3af24842_Out_0_Vector4 = _FoamColor;
            float4 _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Swizzle_6ade92d2005e4e7894588a26122a9d4c_Out_1_Vector4, _Property_7d76aa18002a4bb488b56e6e3af24842_Out_0_Vector4, _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4);
            float4 _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4, _SampleTexture2D_eca122bc311046819a95157ab43caa94_RGBA_0_Vector4, _Multiply_26b8d3b4deeb47728f6d1ed9d4abf3c5_Out_2_Vector4, _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4);
            float4 _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4;
            Unity_Branch_float4(_Property_54712e7ba1864687818d8f787ade3ea7_Out_0_Boolean, _Lerp_da74112103e84495a34f455d4723c64c_Out_3_Vector4, _Lerp_34855b60a79446d187bb3f3883ea57d7_Out_3_Vector4, _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4);
            float _Split_98cb72d2146c4089be6ecde42edf59df_R_1_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[0];
            float _Split_98cb72d2146c4089be6ecde42edf59df_G_2_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[1];
            float _Split_98cb72d2146c4089be6ecde42edf59df_B_3_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[2];
            float _Split_98cb72d2146c4089be6ecde42edf59df_A_4_Float = _Branch_db19d353eb0f4ef58241c5c074ccc3fb_Out_3_Vector4[3];
            float4 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGBA_4_Vector4;
            float3 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3;
            float2 _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RG_6_Vector2;
            Unity_Combine_float(_Split_98cb72d2146c4089be6ecde42edf59df_R_1_Float, _Split_98cb72d2146c4089be6ecde42edf59df_G_2_Float, _Split_98cb72d2146c4089be6ecde42edf59df_B_3_Float, float(0), _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGBA_4_Vector4, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RG_6_Vector2);
            float _Property_3f8b7b25769046f6b3af783a32563bb9_Out_0_Float = Refraction;
            float3 _Swizzle_501785d1544c49919e6cc3f890a170ef_Out_1_Vector3 = _Property_3f8b7b25769046f6b3af783a32563bb9_Out_0_Float.xxx;
            float3 _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3;
            Unity_Lerp_float3(_SceneColor_f35be490bfbc4e6c92e4bcad48cc4eeb_Out_1_Vector3, _Combine_a8c88ccc56e74be4a9ca53f37dac0d78_RGB_5_Vector3, _Swizzle_501785d1544c49919e6cc3f890a170ef_Out_1_Vector3, _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3);
            float _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float;
            Unity_SceneDepth_Linear01_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float);
            float _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float;
            Unity_Multiply_float_float(_SceneDepth_a693584e9cf141d5b8191adbee554ebc_Out_1_Float, _ProjectionParams.z, _Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float);
            float4 _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_f4c2a8f4b03347289c6dc876561794f6_R_1_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[0];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_G_2_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[1];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_B_3_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[2];
            float _Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float = _ScreenPosition_75bb94f3e06741158712149b4a6cb7dd_Out_0_Vector4[3];
            float _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float = _EdgeBlendDistribution;
            float _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float;
            Unity_Add_float(_Split_f4c2a8f4b03347289c6dc876561794f6_A_4_Float, _Property_3855068eb9fb42a796078665bd4ccd5b_Out_0_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float);
            float _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float;
            Unity_Subtract_float(_Multiply_f17221f7d211430aa97f288efe89fbb9_Out_2_Float, _Add_28ba46ca21c4413587fb4fa337b70947_Out_2_Float, _Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float);
            float _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float = _EdgeBlendStrength;
            float _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_5e16353e4540419686b5e77990b105fd_Out_2_Float, _Property_baa5ae08484c432d8b87282d7dbef188_Out_0_Float, _Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float);
            float _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float;
            Unity_Clamp_float(_Multiply_643044c7b36b47768380d9e93502bcc2_Out_2_Float, float(0), float(1), _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float);
            float _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float;
            Unity_Multiply_float_float(2, _Clamp_ec3afd6731b0407687de2cad5fda86ff_Out_3_Float, _Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float);
            float _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float = Opague_Level;
            float _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_5be99a8fddac4b3e9b810a508d518eab_Out_2_Float, _Property_96215e7fbaab46eebf6f4979ac1f3a5e_Out_0_Float, _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float);
            surface.BaseColor = _Lerp_754c08abdeed444fb7b299ae0d8f15b6_Out_3_Vector3;
            surface.Alpha = _Multiply_abd1ec6666c54ba2b33ae13f7150b8b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}
/*
Unity Standard Vertex Color Shader Lib v0.92.1 (for Unity 5.6.0b4)
by defaxer
*/

#ifndef UNITY_VC_INCLUDED
#define UNITY_VC_INCLUDED

#include "../../EcoModKit/Shaders/CurvedHelper.cginc"

#if defined(VERTEXCOLOR) || defined(VERTEXCOLOR_LERP)
float _IntensityVC;
#endif

struct VertexInput_VC
{
    float4 vertex   : POSITION;
#if defined(VERTEXCOLOR) || defined(VERTEXCOLOR_LERP)
    fixed4 color    : COLOR;
#endif
    half3 normal    : NORMAL;
    float2 uv0      : TEXCOORD0;
    float2 uv1      : TEXCOORD1;
#if defined(DYNAMICLIGHTMAP_ON) || defined(UNITY_PASS_META)
    float2 uv2      : TEXCOORD2;
#endif
#ifdef _TANGENT_TO_WORLD
    half4 tangent   : TANGENT;
#endif
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

float4 TexCoords_VC(VertexInput_VC v)
{
    float4 texcoord;
    texcoord.xy = TRANSFORM_TEX(v.uv0, _MainTex); // Always source from uv0
    texcoord.zw = TRANSFORM_TEX(((_UVSec == 0) ? v.uv0 : v.uv1), _DetailAlbedoMap);
    return texcoord;
}

inline half4 VertexGIForward_VC(VertexInput_VC v, float3 posWorld, half3 normalWorld)
{
    half4 ambientOrLightmapUV = 0;
    // Static lightmaps
    #ifdef LIGHTMAP_ON
        ambientOrLightmapUV.xy = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
        ambientOrLightmapUV.zw = 0;
    // Sample light probe for Dynamic objects only (no static or dynamic lightmaps)
    #elif UNITY_SHOULD_SAMPLE_SH
        #ifdef VERTEXLIGHT_ON
            // Approximated illumination from non-important point lights
            ambientOrLightmapUV.rgb = Shade4PointLights(
                unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                unity_4LightAtten0, posWorld, normalWorld);
        #endif

        ambientOrLightmapUV.rgb = ShadeSHPerVertex(normalWorld, ambientOrLightmapUV.rgb);
    #endif

    #ifdef DYNAMICLIGHTMAP_ON
        ambientOrLightmapUV.zw = v.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
    #endif

    return ambientOrLightmapUV;
}

//Forward Pass
struct VertexOutputForwardBase_VC
{
    UNITY_POSITION(pos);
    float4 tex                            : TEXCOORD0;
    float4 eyeVec                         : TEXCOORD1;    // eyeVec.xyz | fogCoord
    float4 tangentToWorldAndPackedData[3] : TEXCOORD2;    // [3x3:tangentToWorld | 1x3:viewDirForParallax or worldPos]
    half4 ambientOrLightmapUV             : TEXCOORD5;    // SH or Lightmap UV
    UNITY_LIGHTING_COORDS(6,7)
    // next ones would not fit into SM2.0 limits, but they are always for SM3.0+
#if UNITY_REQUIRE_FRAG_WORLDPOS && !UNITY_PACK_WORLDPOS_WITH_TANGENT
    float3 posWorld                     : TEXCOORD8;
#endif

    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
#if defined(VERTEXCOLOR) || defined(VERTEXCOLOR_LERP)
    fixed4 color                        : COLOR;
#endif
};

VertexOutputForwardBase_VC vertForwardBase_VC(VertexInput_VC v)
{
    v.vertex = curveVertex(v.vertex, unity_ObjectToWorld, unity_WorldToObject);

    UNITY_SETUP_INSTANCE_ID(v);
    VertexOutputForwardBase_VC o;
    UNITY_INITIALIZE_OUTPUT(VertexOutputForwardBase_VC, o);
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    float4 posWorld = mul(unity_ObjectToWorld, v.vertex);
    #if UNITY_REQUIRE_FRAG_WORLDPOS
        #if UNITY_PACK_WORLDPOS_WITH_TANGENT
            o.tangentToWorldAndPackedData[0].w = posWorld.x;
            o.tangentToWorldAndPackedData[1].w = posWorld.y;
            o.tangentToWorldAndPackedData[2].w = posWorld.z;
        #else
            o.posWorld = posWorld.xyz;
        #endif
    #endif
    o.pos = UnityObjectToClipPos(v.vertex);

    o.tex = TexCoords_VC(v);
    o.eyeVec.xyz = NormalizePerVertexNormal(posWorld.xyz - _WorldSpaceCameraPos);
    float3 normalWorld = UnityObjectToWorldNormal(v.normal);
    #ifdef _TANGENT_TO_WORLD
        float4 tangentWorld = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);

        float3x3 tangentToWorld = CreateTangentToWorldPerVertex(normalWorld, tangentWorld.xyz, tangentWorld.w);
        o.tangentToWorldAndPackedData[0].xyz = tangentToWorld[0];
        o.tangentToWorldAndPackedData[1].xyz = tangentToWorld[1];
        o.tangentToWorldAndPackedData[2].xyz = tangentToWorld[2];
    #else
        o.tangentToWorldAndPackedData[0].xyz = 0;
        o.tangentToWorldAndPackedData[1].xyz = 0;
        o.tangentToWorldAndPackedData[2].xyz = normalWorld;
    #endif

    //We need this for shadow receving
    UNITY_TRANSFER_LIGHTING(o, v.uv1);

    o.ambientOrLightmapUV = VertexGIForward_VC(v, posWorld, normalWorld);

    #ifdef _PARALLAXMAP
        TANGENT_SPACE_ROTATION;
        half3 viewDirForParallax = mul(rotation, ObjSpaceViewDir(v.vertex));
        o.tangentToWorldAndPackedData[0].w = viewDirForParallax.x;
        o.tangentToWorldAndPackedData[1].w = viewDirForParallax.y;
        o.tangentToWorldAndPackedData[2].w = viewDirForParallax.z;
    #endif
#if defined(VERTEXCOLOR) || defined(VERTEXCOLOR_LERP)
    o.color = v.color;
#endif
    UNITY_TRANSFER_FOG_COMBINED_WITH_EYE_VEC(o,o.pos);
    return o;
}

float4 fragForwardBase_VC(VertexOutputForwardBase_VC i) : SV_Target
{
    UNITY_APPLY_DITHER_CROSSFADE(i.pos.xy);

    FRAGMENT_SETUP(s)

    UNITY_SETUP_INSTANCE_ID(i);
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

    UnityLight mainLight = MainLight();
    UNITY_LIGHT_ATTENUATION(atten, i, s.posWorld);

    half occlusion = Occlusion(i.tex.xy);
    UnityGI gi = FragmentGI(s, occlusion, i.ambientOrLightmapUV, atten, mainLight);

    half4 c = UNITY_BRDF_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, gi.light, gi.indirect);
#ifdef VERTEXCOLOR
    c *= i.color * _IntensityVC;
#endif
#ifdef VERTEXCOLOR_LERP
    c *= lerp(float4(1,1,1,1), i.color, _IntensityVC);
#endif
    c.rgb += Emission(i.tex.xy);

    UNITY_EXTRACT_FOG_FROM_EYE_VEC(i);
    UNITY_APPLY_FOG(_unity_fogCoord, c.rgb);
#ifdef VERTEXCOLOR
    s.alpha *= i.color.a;
#endif
#ifdef VERTEXCOLOR_LERP
    s.alpha *= lerp(1, i.color.a, _IntensityVC);
#endif
    return OutputForward(c, s.alpha);
}

//  Additive forward pass (one light per pass)
struct VertexOutputForwardAdd_VC
{
    UNITY_POSITION(pos);
    float4 tex                          : TEXCOORD0;
    float4 eyeVec                       : TEXCOORD1;    // eyeVec.xyz | fogCoord
    float4 tangentToWorldAndLightDir[3] : TEXCOORD2;    // [3x3:tangentToWorld | 1x3:lightDir]
    float3 posWorld                     : TEXCOORD5;
    UNITY_LIGHTING_COORDS(6, 7)

    // next ones would not fit into SM2.0 limits, but they are always for SM3.0+
#if defined(_PARALLAXMAP)
    half3 viewDirForParallax            : TEXCOORD8;
#endif

    UNITY_VERTEX_OUTPUT_STEREO
#if defined(VERTEXCOLOR) || defined(VERTEXCOLOR_LERP)
    fixed4 color                        : COLOR;
#endif
};

VertexOutputForwardAdd_VC vertForwardAdd_VC(VertexInput_VC v)
{
    v.vertex = curveVertex(v.vertex, unity_ObjectToWorld, unity_WorldToObject);

    UNITY_SETUP_INSTANCE_ID(v);
    VertexOutputForwardAdd_VC o;
    UNITY_INITIALIZE_OUTPUT(VertexOutputForwardAdd_VC, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    float4 posWorld = mul(unity_ObjectToWorld, v.vertex);
    o.pos = UnityObjectToClipPos(v.vertex);

    o.tex = TexCoords_VC(v);
    o.eyeVec.xyz = NormalizePerVertexNormal(posWorld.xyz - _WorldSpaceCameraPos);
    o.posWorld = posWorld.xyz;
    float3 normalWorld = UnityObjectToWorldNormal(v.normal);
    #ifdef _TANGENT_TO_WORLD
        float4 tangentWorld = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);

        float3x3 tangentToWorld = CreateTangentToWorldPerVertex(normalWorld, tangentWorld.xyz, tangentWorld.w);
        o.tangentToWorldAndLightDir[0].xyz = tangentToWorld[0];
        o.tangentToWorldAndLightDir[1].xyz = tangentToWorld[1];
        o.tangentToWorldAndLightDir[2].xyz = tangentToWorld[2];
    #else
        o.tangentToWorldAndLightDir[0].xyz = 0;
        o.tangentToWorldAndLightDir[1].xyz = 0;
        o.tangentToWorldAndLightDir[2].xyz = normalWorld;
    #endif
    //We need this for shadow receiving and lighting
    UNITY_TRANSFER_LIGHTING(o, v.uv1);

    float3 lightDir = _WorldSpaceLightPos0.xyz - posWorld.xyz * _WorldSpaceLightPos0.w;
    #ifndef USING_DIRECTIONAL_LIGHT
        lightDir = NormalizePerVertexNormal(lightDir);
    #endif
    o.tangentToWorldAndLightDir[0].w = lightDir.x;
    o.tangentToWorldAndLightDir[1].w = lightDir.y;
    o.tangentToWorldAndLightDir[2].w = lightDir.z;

#ifdef _PARALLAXMAP
    TANGENT_SPACE_ROTATION;
    o.viewDirForParallax = mul(rotation, ObjSpaceViewDir(v.vertex));
#endif

#ifdef VERTEXCOLOR
    o.color = v.color; //lerp(fixed4(1,1,1,1), fixed4(1,1,1,1) * v.color, _IntensityVC);
#endif

    UNITY_TRANSFER_FOG_COMBINED_WITH_EYE_VEC(o, o.pos);
    return o;
}

float4 fragForwardAdd_VC(VertexOutputForwardAdd_VC i) : SV_Target
{
    UNITY_APPLY_DITHER_CROSSFADE(i.pos.xy);

    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

    FRAGMENT_SETUP_FWDADD(s)

    UNITY_LIGHT_ATTENUATION(atten, i, s.posWorld)
    UnityLight light = AdditiveLight(IN_LIGHTDIR_FWDADD(i), atten);
    UnityIndirect noIndirect = ZeroIndirect();

    half4 c = UNITY_BRDF_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, light, noIndirect);
#ifdef VERTEXCOLOR
    c *= i.color;
#endif

    UNITY_EXTRACT_FOG_FROM_EYE_VEC(i);
    UNITY_APPLY_FOG_COLOR(_unity_fogCoord, c.rgb, half4(0,0,0,0)); // fog towards black in additive pass
    return OutputForward(c, s.alpha);
}

//Deferred Pass
struct VertexOutputDeferred_VC
{
    float4 pos							: SV_POSITION;
    float4 tex							: TEXCOORD0;
    float3 eyeVec 						: TEXCOORD1;
    float4 tangentToWorldAndPackedData[3]	: TEXCOORD2;	// [3x3:tangentToWorld | 1x3:viewDirForParallax]
    float4 ambientOrLightmapUV			: TEXCOORD5;	// SH or Lightmap UVs

#if defined(VERTEXCOLOR) || defined(VERTEXCOLOR_LERP)
    fixed4 color : COLOR;
#endif

#if UNITY_SPECCUBE_BOX_PROJECTION || UNITY_LIGHT_PROBE_PROXY_VOLUME
    float3 posWorld						: TEXCOORD6;
#endif

#if UNITY_OPTIMIZE_TEXCUBELOD
#if UNITY_SPECCUBE_BOX_PROJECTION
    float3 reflUVW				: TEXCOORD7;
#else
    float3 reflUVW				: TEXCOORD6;
#endif
#endif

    UNITY_VERTEX_OUTPUT_STEREO
};

VertexOutputDeferred_VC vertDeferred_VC(VertexInput_VC v)
{
    v.vertex = curveVertex(v.vertex, unity_ObjectToWorld, unity_WorldToObject);

    UNITY_SETUP_INSTANCE_ID(v);
    VertexOutputDeferred_VC o;
    UNITY_INITIALIZE_OUTPUT(VertexOutputDeferred_VC, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    float4 posWorld = mul(unity_ObjectToWorld, v.vertex);
#if UNITY_SPECCUBE_BOX_PROJECTION || UNITY_LIGHT_PROBE_PROXY_VOLUME
    o.posWorld = posWorld;
#endif
    o.pos = UnityObjectToClipPos(v.vertex);

    o.tex = TexCoords_VC(v);
    o.eyeVec.xyz = NormalizePerVertexNormal(posWorld.xyz - _WorldSpaceCameraPos);
    float3 normalWorld = UnityObjectToWorldNormal(v.normal);
#ifdef _TANGENT_TO_WORLD
    float4 tangentWorld = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);

    float3x3 tangentToWorld = CreateTangentToWorldPerVertex(normalWorld, tangentWorld.xyz, tangentWorld.w);
    o.tangentToWorldAndPackedData[0].xyz = tangentToWorld[0];
    o.tangentToWorldAndPackedData[1].xyz = tangentToWorld[1];
    o.tangentToWorldAndPackedData[2].xyz = tangentToWorld[2];
#else
    o.tangentToWorldAndPackedData[0].xyz = 0;
    o.tangentToWorldAndPackedData[1].xyz = 0;
    o.tangentToWorldAndPackedData[2].xyz = normalWorld;
#endif

    o.ambientOrLightmapUV = 0;
#ifndef LIGHTMAP_OFF
    o.ambientOrLightmapUV.xy = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#elif UNITY_SHOULD_SAMPLE_SH
    o.ambientOrLightmapUV.rgb = ShadeSHPerVertex(normalWorld, o.ambientOrLightmapUV.rgb);
#endif
#ifdef DYNAMICLIGHTMAP_ON
    o.ambientOrLightmapUV.zw = v.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
#endif

#ifdef _PARALLAXMAP
    TANGENT_SPACE_ROTATION;
    float3 viewDirForParallax = mul(rotation, ObjSpaceViewDir(v.vertex));
    o.tangentToWorldAndPackedData[0].w = viewDirForParallax.x;
    o.tangentToWorldAndPackedData[1].w = viewDirForParallax.y;
    o.tangentToWorldAndPackedData[2].w = viewDirForParallax.z;
#endif
#if defined(VERTEXCOLOR) || defined(VERTEXCOLOR_LERP)
    o.color = v.color;
#endif

#if UNITY_OPTIMIZE_TEXCUBELOD
    o.reflUVW = reflect(o.eyeVec, normalWorld);
#endif

    return o;
}

void fragDeferred_VC(
    VertexOutputDeferred_VC i,
    out float4 outDiffuse : SV_Target0,			// RT0: diffuse color (rgb), occlusion (a)
    out float4 outSpecSmoothness : SV_Target1,	// RT1: spec color (rgb), smoothness (a)
    out float4 outNormal : SV_Target2,			// RT2: normal (rgb), --unused, very low precision-- (a)
    out float4 outEmission : SV_Target3			// RT3: emission (rgb), --unused-- (a)
)
{
#if (SHADER_TARGET < 30)
    outDiffuse = 1;
    outSpecSmoothness = 1;
    outNormal = 0;
    outEmission = 0;
    return;
#endif

    FRAGMENT_SETUP(s)
#if UNITY_OPTIMIZE_TEXCUBELOD
        s.reflUVW = i.reflUVW;
#endif

    // no analytic lights in this pass
    UnityLight dummyLight = DummyLight();
    float atten = 1;

    // only GI
    float occlusion = Occlusion(i.tex.xy);
#if UNITY_ENABLE_REFLECTION_BUFFERS
    bool sampleReflectionsInDeferred = false;
#else
    bool sampleReflectionsInDeferred = true;
#endif

    UnityGI gi = FragmentGI(s, occlusion, i.ambientOrLightmapUV, atten, dummyLight, sampleReflectionsInDeferred);

    float3 color = UNITY_BRDF_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, gi.light, gi.indirect).rgb;
#ifdef VERTEXCOLOR
    color *= i.color * _IntensityVC;
#endif
#ifdef VERTEXCOLOR_LERP
    color *= lerp(float3(1, 1, 1), i.color.rgb, _IntensityVC);
#endif
    color += UNITY_BRDF_GI(s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, occlusion, gi);

#ifdef _EMISSION
    color += Emission(i.tex.xy);
#endif

#ifndef UNITY_HDR_ON
    color.rgb = exp2(-color.rgb);
#endif

#ifdef VERTEXCOLOR
    s.diffColor *= i.color.rgb * _IntensityVC;
    s.specColor *= i.color.rgb * _IntensityVC;
#endif
#ifdef VERTEXCOLOR_LERP
    s.diffColor = lerp(s.diffColor, s.diffColor * i.color.rgb, _IntensityVC);
    s.specColor = lerp(s.specColor, s.specColor * i.color.rgb, _IntensityVC);
#endif

    outDiffuse = float4(s.diffColor, occlusion);
    outSpecSmoothness = float4(s.specColor, s.smoothness);
    outNormal = float4(s.normalWorld*0.5 + 0.5, 1);
    outEmission = float4(color, 1);
}

#endif

using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEditor.Rendering.Universal;
using UnityEditor.Rendering.Universal.ShaderGUI;
using UnityEditorInternal;


namespace UnityEditor
{
    class SublimationDissolveShader : BaseShaderGUI
    {
        // Properties
        private LitGUI.LitProperties litProperties;

        // private Texture dissolveTexture = null;
        // private _DissolveRate("Dissolve Rate", Range(0.0, 1.0)) = 0.0
        // private _DissolveEdgeFadeIn("Dissolve Edge Fade In", Range(0.0, 1.0)) = 0.35
        // private _DissolveEdgeIn("Dissolve Edge In", Range(0.0, 1.0)) = 0.45
        // private _DissolveEdgeOut("Dissolev Edge Out", Range(0.0, 1.0)) = 0.55
        // private _DissolveEdgeFadeOut("Dissolve Edge Fade Out", Range(0.0, 1.0)) = 0.65

        MaterialProperty dissolveMapProp = null;
        MaterialProperty dissolveRateProp = null;
        MaterialProperty dissolveEdgeEmissionColorProp = null;
        MaterialProperty dissolveEdgeFadeInProp = null;
        MaterialProperty dissolveEdgeInProp = null;
        MaterialProperty dissolveEdgeOutProp = null;
        MaterialProperty dissolveEdgeFadeOutProp = null;

        private bool m_AddtionalFoldout = true;

        // collect properties from the material properties
        public override void FindProperties(MaterialProperty[] properties)
        {
            base.FindProperties(properties);
            litProperties = new LitGUI.LitProperties(properties);
        }

        // material changed check
        public override void MaterialChanged(Material material)
        {
            if (material == null)
                throw new ArgumentNullException("material");

            SetMaterialKeywords(material, LitGUI.SetMaterialKeywords);
        }

        // material main surface options
        public override void DrawSurfaceOptions(Material material)
        {
            if (material == null)
                throw new ArgumentNullException("material");

            // Use default labelWidth
            EditorGUIUtility.labelWidth = 0f;

            // Detect any changes to the material
            EditorGUI.BeginChangeCheck();
            if (litProperties.workflowMode != null)
            {
                DoPopup(LitGUI.Styles.workflowModeText, litProperties.workflowMode, Enum.GetNames(typeof(LitGUI.WorkflowMode)));
            }
            if (EditorGUI.EndChangeCheck())
            {
                foreach (var obj in blendModeProp.targets)
                    MaterialChanged((Material)obj);
            }
            base.DrawSurfaceOptions(material);
        }

        // material main surface inputs
        public override void DrawSurfaceInputs(Material material)
        {
            base.DrawSurfaceInputs(material);
            LitGUI.Inputs(litProperties, materialEditor, material);
            DrawEmissionProperties(material, true);
            DrawTileOffset(materialEditor, baseMapProp);
        }

        // material main advanced options
        public override void DrawAdvancedOptions(Material material)
        {
            if (litProperties.reflections != null && litProperties.highlights != null)
            {
                EditorGUI.BeginChangeCheck();
                materialEditor.ShaderProperty(litProperties.highlights, LitGUI.Styles.highlightsText);
                materialEditor.ShaderProperty(litProperties.reflections, LitGUI.Styles.reflectionsText);
                if (EditorGUI.EndChangeCheck())
                {
                    MaterialChanged(material);
                }
            }

            base.DrawAdvancedOptions(material);
        }

        public override void OnGUI(MaterialEditor materialEditorIn, MaterialProperty[] properties)
        {
            dissolveMapProp = FindProperty("_DissolveMap", properties);
            dissolveRateProp = FindProperty("_DissolveRate", properties);
            dissolveEdgeEmissionColorProp = FindProperty("_DissolveEdgeEmissionColor", properties);
            dissolveEdgeFadeInProp = FindProperty("_DissolveEdgeFadeIn", properties);
            dissolveEdgeInProp = FindProperty("_DissolveEdgeIn", properties);
            dissolveEdgeOutProp = FindProperty("_DissolveEdgeOut", properties);
            dissolveEdgeFadeOutProp = FindProperty("_DissolveEdgeFadeOut", properties);

            base.OnGUI(materialEditorIn, properties);
        }


        public override void DrawAdditionalFoldouts(Material material)
        {
            EditorGUI.BeginChangeCheck();

            m_AddtionalFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_AddtionalFoldout, "Addtional");

            // materialEditor.TextureProperty();
            if (m_AddtionalFoldout)
            {
                materialEditor.RangeProperty(dissolveRateProp, "Dissolve Rate");
                materialEditor.TextureProperty(dissolveMapProp, "Dissolve Map");
                materialEditor.ColorProperty(dissolveEdgeEmissionColorProp, "Dissolve Edge Emission Color");
                materialEditor.RangeProperty(dissolveEdgeFadeInProp, "Dissolve Edge Fade In");
                materialEditor.RangeProperty(dissolveEdgeInProp, "Dissolve Edge In");
                materialEditor.RangeProperty(dissolveEdgeOutProp, "Dissolve Edge Out");
                materialEditor.RangeProperty(dissolveEdgeFadeOutProp, "Dissolve Edge Fade Out");
            }

            if (EditorGUI.EndChangeCheck())
            {
                // material.SetTexture("_DissolveMap", dissolveTexture);
            }

            base.DrawAdditionalFoldouts(material);
        }

        public override void AssignNewShaderToMaterial(Material material, Shader oldShader, Shader newShader)
        {
            if (material == null)
                throw new ArgumentNullException("material");

            // _Emission property is lost after assigning Standard shader to the material
            // thus transfer it before assigning the new shader
            if (material.HasProperty("_Emission"))
            {
                material.SetColor("_EmissionColor", material.GetColor("_Emission"));
            }

            base.AssignNewShaderToMaterial(material, oldShader, newShader);

            if (oldShader == null || !oldShader.name.Contains("Legacy Shaders/"))
            {
                SetupMaterialBlendMode(material);
                return;
            }

            SurfaceType surfaceType = SurfaceType.Opaque;
            BlendMode blendMode = BlendMode.Alpha;
            if (oldShader.name.Contains("/Transparent/Cutout/"))
            {
                surfaceType = SurfaceType.Opaque;
                material.SetFloat("_AlphaClip", 1);
            }
            else if (oldShader.name.Contains("/Transparent/"))
            {
                // NOTE: legacy shaders did not provide physically based transparency
                // therefore Fade mode
                surfaceType = SurfaceType.Transparent;
                blendMode = BlendMode.Alpha;
            }
            material.SetFloat("_Surface", (float)surfaceType);
            material.SetFloat("_Blend", (float)blendMode);

            if (oldShader.name.Equals("Standard (Specular setup)"))
            {
                material.SetFloat("_WorkflowMode", (float)LitGUI.WorkflowMode.Specular);
                Texture texture = material.GetTexture("_SpecGlossMap");
                if (texture != null)
                    material.SetTexture("_MetallicSpecGlossMap", texture);
            }
            else
            {
                material.SetFloat("_WorkflowMode", (float)LitGUI.WorkflowMode.Metallic);
                Texture texture = material.GetTexture("_MetallicGlossMap");
                if (texture != null)
                    material.SetTexture("_MetallicSpecGlossMap", texture);
            }

            MaterialChanged(material);
        }
    }
}
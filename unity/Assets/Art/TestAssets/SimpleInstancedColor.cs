// Copyright (c) Strange Loop Games. All rights reserved.
// See LICENSE file in the project root for full license information.

using UnityEngine;

[ExecuteInEditMode]
public class SimpleInstancedColor : MonoBehaviour
{
    private Renderer rendererComponent;

    public bool reinit = false;

    void Start()
    {
        this.rendererComponent = this.GetComponent<Renderer>();
        this.Init();
    }

    public void Update()
    {
        if (!reinit)
            return;

        this.Init();

        reinit = false;
    }

    private void Init()
    {
        MaterialPropertyBlock properties = new MaterialPropertyBlock();
        float alpha = UnityEngine.Random.Range(0.1f, .9f);
        float pollution = UnityEngine.Random.Range(0f, 1.0f);
        this.rendererComponent.GetPropertyBlock(properties);
        properties.SetFloat("_Cutoff", alpha);
        properties.SetFloat("_Pollution", pollution);
        this.rendererComponent.SetPropertyBlock(properties);
    }
}

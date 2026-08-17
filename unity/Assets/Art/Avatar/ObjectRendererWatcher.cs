namespace Eco.Client
{
    using System;
    using UnityEngine;

    public class ObjectRendererWatcher : MonoBehaviour
    {
        [Tooltip("Based on this renderer state - turn on or off linked targets")]
        [SerializeField] Renderer source;

        bool cachedState;

        [SerializeField] GameObject[] targets = Array.Empty<GameObject>();

        void Start() => this.cachedState = !this.source.enabled;

        void Update()
        {
            if (this.cachedState != this.source.enabled)
            {
                this.cachedState = this.source.enabled;
                foreach (var target in this.targets)
                    if (target != null) target.SetActive(this.cachedState);
            }
        }
    }
}

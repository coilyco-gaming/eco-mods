using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Eco.Client
{
    public class noop : MonoBehaviour
    {
        // SLG uses this function to handle sounds.
        // We don't use sounds, so we don't do anything here.
        public void SetAnimNum(int animationValue = 0) { }

        // Start is called before the first frame update
        void Start() { }

        // Update is called once per frame
        void Update() { }
    }
}

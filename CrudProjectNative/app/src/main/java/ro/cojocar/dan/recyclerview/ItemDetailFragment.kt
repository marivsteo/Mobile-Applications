package ro.cojocar.dan.recyclerview

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import kotlinx.android.synthetic.main.activity_item_detail.*
import kotlinx.android.synthetic.main.item_detail.view.*
import ro.cojocar.dan.recyclerview.cameras.Cameras

class ItemDetailFragment : Fragment() {

  private var item: Cameras.Camera? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    arguments?.let {
      if (it.containsKey(ARG_ITEM_ID)) {
        // Load the dummy content specified by the fragment
        // arguments. In a real-world scenario, use a Loader
        // to load content from a content provider.
        item = Cameras.CAMERA_MAP[it.getString(ARG_ITEM_ID)]
        activity?.toolbar_layout?.title = item?.name
      }
    }
  }

  override fun onCreateView(
      inflater: LayoutInflater, container: ViewGroup?,
      savedInstanceState: Bundle?
  ): View? {
    val rootView = inflater.inflate(R.layout.item_detail, container, false)

    // Show the dummy content as text in a TextView.
    item?.let {
      rootView.item_detail.text = Cameras.makeDetails(it)
    }
    return rootView
  }

  companion object {
    const val ARG_ITEM_ID = "item_id"
  }
}

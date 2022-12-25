<?php

require_once('api.php');

/**
 * Class Onboarding_banner_slots
 * @property Onboarding_banner_slots_model $banner_model
 */
class Onboarding_banner_slots extends Api
{
    /**
     *  Constructor.
     */
    public function __construct()
    {
        parent::__construct();
        $this->load->model('onboarding_banner_slots_model', 'banner_model');
    }

    /**
     * API get data OnboardingBannerSlots
     *
     * @return json
     */
    public function get()
    {
        $bannerSlots = $this->banner_model->getAll($this->getBaseDate());
        if (empty($bannerSlots)) {
            return $this->outputJsonResponse(array());
        }

        $cookieKey = sprintf('displayed_banners_%d', $this->session->userdata('memberid'));
        $bannerSlot = $this->getBannerByCookieKey($bannerSlots, $cookieKey);
        $this->saveDisplayedBannerInCookie($cookieKey, $bannerSlot['id']);
        return $this->outputJsonResponse($bannerSlot);
    }

    /**
     * Get all onboarding banners frames
     *
     * @return json
     */
    public function getAllBanners()
    {
        $banners = $this->banner_model->getAll($this->getBaseDate());
        if (empty($banners)) {
            return $this->outputJsonResponse(array());
        }

        $itemOnlyBanners = array_values(array_filter($banners, function ($banner) {
            return isset($banner['item']);
        }));
        $onboardingListFrames = array_map(function ($banner) {
            $frame = $banner['item'];
            if ($banner['up_point']) {
                $frame['up_point'] = $banner['up_point'];
            }
            return $frame;
        }, $itemOnlyBanners);
        return $this->outputJsonResponse($onboardingListFrames);
    }

    /**
     * Get one to display in banners list
     *
     * @param array     $bannerSlots
     * @param string    $cookieKey
     * @return array
     */
    private function getBannerByCookieKey($bannerSlots, $cookieKey)
    {
        $bannerId = $_COOKIE[$cookieKey];
        if (is_null($bannerId)) {
            return $bannerSlots[0];
        }
        return $this->getFirstBannerExisted($bannerSlots, $bannerId);
    }

    /**
     * Save displayed banner in cookie
     *
     * @param string $cookieKey
     * @param string $bannerId
     * @return void
     */
    private function saveDisplayedBannerInCookie($cookieKey, $bannerId)
    {
        $expireCookie = strtotime('today 23:59:59');
        setcookie($cookieKey, $bannerId, $expireCookie, '/');
    }

    /**
     * Get the banner which have not display
     *
     * @param array $bannerSlots
     * @param array $displayBannerID
     * @return array
     */
    private function getFirstBannerExisted($bannerSlots, $displayBannerID)
    {
        foreach ($bannerSlots as $banner) {
            if ($banner['id'] < $displayBannerID) {
                return $banner;
            }
        }
        return $bannerSlots[0];
    }
}

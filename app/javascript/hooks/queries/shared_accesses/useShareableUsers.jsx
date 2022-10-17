import { useQuery } from 'react-query';
import axios from '../../../helpers/Axios';

export default function useShareableUsers(friendlyId, input, isThreeCharacters) {
  const params = {
    search: input,
  };

  return useQuery(
    ['getShareableUsers', { ...params }],
    () => axios.get(`/shared_accesses/${friendlyId}/shareable_users.json`, { params }).then((resp) => resp.data.data),
    {
      keepPreviousData: true,
      enabled: isThreeCharacters,
    },
  );
}

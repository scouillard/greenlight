import { useQuery } from 'react-query';
import axios from 'axios';

export default function useSharedUsers(roomId) {
  return useQuery('getSharedUsers', () => axios.get(`/api/v1/shared_accesses/${roomId}/shared_users.json`, {
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
  }).then((resp) => resp.data.data));
}
